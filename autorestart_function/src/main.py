# Import the functions_framework library, which is the official framework provided by Google Cloud
# for writing event-driven Cloud Functions (v2). It handles the HTTP requests sent by Eventarc
# and translates them into Python CloudEvent objects.
import functions_framework

# Import the Google Cloud Compute Engine (GCE) API client library.
# We will use this library to call the underlying GCE APIs (specifically the start method)
# to wake up the virtual machine if it has been preempted or stopped.
from google.cloud import compute_v1

# The @functions_framework.cloud_event decorator explicitly tells the Cloud Functions runtime
# that the function below is designed to handle standard CloudEvents. 
# Eventarc delivers all events using this open standard.
@functions_framework.cloud_event
def restart_vm(cloud_event):
    """
    This is the core handler function. It gets triggered whenever Eventarc detects a matching 
    Compute Engine audit log (such as a preemption event).
    
    Args:
        cloud_event: An object containing all the metadata and the payload of the event.
    """
    
    # Extract the core 'data' dictionary from the CloudEvent object.
    # This 'data' payload actually contains the original raw JSON log entry from Cloud Audit Logs.
    data = cloud_event.data
    
    # In GCP Cloud Audit Logs, all the crucial operational details are nested inside 
    # the 'protoPayload' field. We use the safe .get() method to retrieve it, 
    # defaulting to an empty dictionary to prevent any KeyError exceptions.
    proto_payload = data.get("protoPayload", {})
    
    # The 'resourceName' field strictly identifies which specific cloud resource triggered this event.
    # It typically looks like a long path string, for example: 
    # "projects/jason-hsbc/zones/europe-west2-c/instances/tf-vpc0-subnet0-openclaw"
    resource_name = proto_payload.get("resourceName", "")

    # Define the exact name of the "target virtual machine" that we care about.
    # This is the highly-valued Spot instance designated for running OpenClaw.
    target_vm = "tf-vpc0-subnet0-openclaw"
    
    # Perform a strict safety interception (filtering) check:
    # Even though we already configured Eventarc in Terraform to filter events, 
    # we add an extra layer of defense here in the code just to be absolutely bulletproof.
    # If the name of the machine that triggered the event does not match our target_vm, 
    # we simply exit the function and do absolutely nothing.
    if target_vm not in resource_name:
        print(f"Ignored event for {resource_name} (This is not our designated target machine)")
        return

    # Since 'resource_name' is a fully qualified path like:
    # "projects/PROJECT_ID/zones/ZONE_ID/instances/INSTANCE_NAME"
    # We need to split this string by the '/' character into a list of individual components.
    parts = resource_name.split('/')
    
    # Verify that the resulting list has a sufficient length (it should normally be >= 6 elements).
    # This acts as a safeguard to prevent any 'IndexError' (out-of-bounds array access) later on.
    if len(parts) >= 6:
        # Index 1 corresponds to the GCP Project ID (e.g., "jason-hsbc")
        project_id = parts[1]
        
        # Index 3 corresponds to the GCP Zone where the machine resides (e.g., "europe-west2-c")
        zone = parts[3]
        
        # Index 5 corresponds to the actual name of the virtual machine (e.g., "tf-vpc0-subnet0-openclaw")
        instance_name = parts[5]
        
        # Print an informative logging statement. This helps us easily track the execution 
        # flow and status when inspecting the GCP Logs Explorer console.
        print(f"Action initiated! Attempting to start instance {instance_name} in project {project_id}, zone {zone}...")
        
        # Instantiate the Compute Engine API client.
        # Because we attached a specific Service Account to this Cloud Function via Terraform, 
        # this client will automatically authenticate using that Service Account's identity and permissions.
        client = compute_v1.InstancesClient()
        
        # Construct the formal 'StartInstanceRequest' object.
        # We must explicitly tell the Google Cloud API the exact project, zone, and instance name to start.
        request = compute_v1.StartInstanceRequest(
            project=project_id,
            zone=zone,
            instance=instance_name
        )
        
        # Send the request to GCP to officially command the underlying hardware to boot up the machine!
        # This is a synchronous API call that dispatches the command to the Google Cloud backend.
        client.start(request=request)
        
        # The operation has completed! Leave a triumphant footprint in the logs to confirm success.
        print(f"Start command successfully dispatched! The instance {instance_name} should be waking up now!")
    else:
        # Just in case the 'resource_name' format is malformed or highly unusual, 
        # print a warning to the logs to help with future debugging and troubleshooting.
        print(f"Failed to parse the resource path correctly. Unrecognized format: {resource_name}")
