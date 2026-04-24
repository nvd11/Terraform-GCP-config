# 导入 functions_framework，这是 Google Cloud Functions (v2) 官方推荐的事件驱动型函数的入口框架
# 它能帮我们把 Eventarc 传过来的原生 HTTP 触发器请求解析为 Python 里的事件对象
import functions_framework

# 导入 Google Cloud Compute Engine (GCE) 的 API 客户端库
# 我们需要用这个库去调用云底层的 start 接口，把关机或被抢占的虚拟机给拉起来
from google.cloud import compute_v1

# 这是一个装饰器，告诉 Cloud Functions 运行环境：下面这个函数是用来处理 CloudEvents 事件的
# CloudEvents 是一个开放标准，Eventarc 发送的所有事件都是基于这个标准的
@functions_framework.cloud_event
def restart_vm(cloud_event):
    """
    这是我们的核心处理函数，当 Eventarc 监听到 Compute Engine 的审计日志（如抢占事件）时，就会触发执行这里。
    参数 cloud_event: 包含了这次事件所有的元数据和负载信息（Payload）。
    """
    
    # 从云事件对象中提取出最核心的 data 字典
    # 这里的 data 实际上就是那条触发事件的原始日志内容（JSON 格式）
    data = cloud_event.data
    
    # 在 GCP 的审计日志（Audit Log）里，具体的操作细节都藏在 protoPayload 这个字段下
    # 我们用 .get() 方法安全地提取它，如果拿不到就给个空字典防止程序崩溃
    proto_payload = data.get("protoPayload", {})
    
    # resourceName 字段记录了到底是哪个云资源触发了这个事件
    # 它的格式一般是长长的一串，比如: "projects/jason-hsbc/zones/europe-west2-c/instances/tf-vpc0-subnet0-openclaw"
    resource_name = proto_payload.get("resourceName", "")

    # 定义我们特别关心的“目标虚拟机”的名称
    # 也就是老板您最看重的那台专门用来跑 OpenClaw 的 Spot 机器
    target_vm = "tf-vpc0-subnet0-openclaw"
    
    # 做一个安全拦截（过滤）校验：
    # 虽然我们在 Terraform 层面已经让 Eventarc 过滤了，但为了万无一失，我们在代码里再加一层保险。
    # 只要触发事件的机器名字不是咱们的 target_vm，我们就直接退出，不做任何处理。
    if target_vm not in resource_name:
        print(f"Ignored event for {resource_name} (这不是我们关心的目标机器哦)")
        return

    # 由于 resource_name 是类似 "projects/PROJECT_ID/zones/ZONE_ID/instances/INSTANCE_NAME" 的全路径
    # 所以我们要用 '/' 把它切成一个个的小块，放进一个列表里
    parts = resource_name.split('/')
    
    # 确认切出来的列表长度是否达标（正常情况下肯定 >= 6）
    # 这样可以防止数组越界报错
    if len(parts) >= 6:
        # 下标 1 对应的位置就是项目 ID（比如 "jason-hsbc"）
        project_id = parts[1]
        
        # 下标 3 对应的位置就是机器所在的可用区（比如 "europe-west2-c"）
        zone = parts[3]
        
        # 下标 5 对应的位置就是机器的真正名字（比如 "tf-vpc0-subnet0-openclaw"）
        instance_name = parts[5]
        
        # 在日志里打印一条提示信息，方便我们在 GCP 控制台的 Logs Explorer 里追踪执行情况
        print(f"准备大显身手啦！开始唤醒项目 {project_id} 区域 {zone} 下的机器 {instance_name}...")
        
        # 实例化 Compute Engine 的 API 客户端
        # 因为我们在 Terraform 里配置了绑定的 Service Account，所以这里会自动带上那个 SA 的身份和权限去调用 API
        client = compute_v1.InstancesClient()
        
        # 构造一个“启动虚拟机”的请求对象 (StartInstanceRequest)
        # 需要清楚地告诉谷歌：在哪个项目、哪个区、启动哪台机器
        request = compute_v1.StartInstanceRequest(
            project=project_id,
            zone=zone,
            instance=instance_name
        )
        
        # 发送请求，正式命令底层硬件把机器拉起来！
        # 这里是同步调用，API 会把指令发给 GCP 后台
        client.start(request=request)
        
        # 操作完成！在日志里留下胜利的脚印
        print(f"唤醒指令已经成功发送！机器 {instance_name} 马上就会原地复活啦！")
    else:
        # 万一 resource_name 格式很奇怪，不符合常规路径，就在日志里提醒一下，方便排错
        print(f"解析资源路径失败了，它长这个样子: {resource_name}")
