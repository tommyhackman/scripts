# coding:utf-8
import requests
import json
import sys
import time

url = 'http://job.turing.speiyou.cn:9999'
# url = 'http://47.95.65.178:9999'
manager_url = url + "/manager"
executor_url = url + "/executor"
success_status = "SUCCEEDED"
running_status = "RUNNING"


def is_positive_int(x):
    try:
        return int(x) > 0
    except ValueError:
        return False


# 获取 session.id 去请求任务状态
def get_session_id(username, password):
    params = {'action': 'login', 'username': username, 'password': password}
    response = requests.post(url, params)
    return json.loads(response.text)["session.id"]


# example: project#flow#job    以,分割
def validate_jobs(jobs_str, session_id):
    jobs_str_splitter = ","
    job_splitter = "#"
    jobs = jobs_str.split(jobs_str_splitter)
    for job in jobs:
        project_name, flow_name, job_name = tuple(job.split(job_splitter))
        # 默认只看最新执行的结果
        params = {"session.id": session_id, "ajax": "fetchFlowExecutions", "project": project_name, "flow": flow_name,
                  "start": "0", "length": "1"}
        executions = json.loads(requests.get(manager_url, params).text)
        # 先判断是否有历史执行记录
        if executions["total"] > 0:
            # 1. 先查看是否有运行中的flow
            # 2. 如果没有运行中的，则查看最近运行的一次的状态
            status = executions["executions"][0]["status"]
            if status == running_status:
                exec_id = executions["executions"][0]["execId"]
                nodes = json.loads(requests.get(executor_url, {"session.id": session_id, "ajax": "fetchexecflow",
                                                               "execid": exec_id}).text)["nodes"]
                for node in nodes:
                    if node["nestedId"] == job_name:
                        if node["status"] != success_status:
                            print(project_name, flow_name, job_name, node["status"])
                            return False
            elif status != success_status:
                print(status)
                return False
        else:
            print(project_name, flow_name, job_name, "not start")
            return False
    print("all dependencies across project is ok")
    return True


# todo 脚本生产环境部署方式
# param1 project#flow#job(多个依赖之间用逗号连接)
# param2 最长依赖检查<等待分钟数
if __name__ == '__main__':
    print("start rely check")
    sid = get_session_id("", "5enfnTI2ZDsM7LlJ")
    #  校验参数
    if len(sys.argv) != 2:
        print("params not fit expect")
        sys.exit(1)
    else:
        jobs_details = sys.argv[1]
        print("jobs_rely: ", jobs_details)
        while True:
            can_continue = validate_jobs(jobs_details, sid)
            if can_continue:
                sys.exit(0)
            else:
                time.sleep(60)
