import functions_framework
from google.cloud import compute_v1

@functions_framework.cloud_event
def restart_vm(cloud_event):
    data = cloud_event.data
    proto_payload = data.get("protoPayload", {})
    resource_name = proto_payload.get("resourceName", "")

    target_vm = "tf-vpc0-subnet0-openclaw"
    if target_vm not in resource_name:
        print(f"Ignored event for {resource_name}")
        return

    parts = resource_name.split('/')
    if len(parts) >= 6:
        project_id = parts[1]
        zone = parts[3]
        instance_name = parts[5]
        
        print(f"Starting instance {instance_name} in project {project_id}, zone {zone}...")
        client = compute_v1.InstancesClient()
        request = compute_v1.StartInstanceRequest(
            project=project_id,
            zone=zone,
            instance=instance_name
        )
        client.start(request=request)
        print("Start request sent.")
