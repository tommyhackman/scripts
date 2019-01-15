# coding:utf-8
import os
import shutil


# 所有用户job 文件名,文件路径 map
def list_job_paths(root_dir):
    d = dict()
    for root, dirs, files in os.walk(root_dir):
        # path = os.path.join(root_dir, lists)
        for file_name in files:
            path = root + os.sep + file_name
            if os.path.isfile(path) & file_name.endswith(".job"):
                d.setdefault(file_name.replace(".job", ""), path)
    return d


# 生成跨项目依赖Job
def generate_jobs_rely(rely_job_dir):
    # 如果依赖job文件夹存在就删除再次生成新的
    if os.path.exists(rely_job_dir):
        shutil.rmtree(rely_job_dir)
    os.mkdir(rely_job_dir)
    # 读取配置文件的依赖
    for job_name, dependencies in relay_config.items():
        rely_job_path = rely_job_dir + os.sep + job_name + generate_suffix + ".job"
        #  生成新文件
        writer = open(rely_job_path, 'w')
        command = "command=sh ../generator/rely_check.sh {dep}"
        writer.write("type=command\n")
        writer.write(command.format(dep=dependencies))
        writer.close()
        # 添加项目依赖


# 更新job dependencies属性
def update_job_dependencies():
    for job_name, dependencies in relay_config.items():
        reader = open(jobs.get(job_name), 'r')
        props = reader.readlines()
        for p in props:
            if p.strip() == "":
                props.remove(p)
        reader.close()

        new_deps_str = "dependencies="
        for prop in props:
            if prop.startswith("dependencies="):
                # 存在依赖 重构依赖
                props.remove(prop)
                dep_key, deps = prop.split("=")
                for dep in deps.split(","):
                    if not dep.strip().endswith(generate_suffix):
                        new_deps_str = new_deps_str + dep.strip() + ","
                break

        # 添加新生成的跨项目依赖
        new_deps_str = new_deps_str + job_name + generate_suffix
        props.append(new_deps_str.strip() + os.linesep)
        writer = open(jobs.get(job_name), 'w+')
        writer.writelines(props)
        writer.close()



# 获取跨项目依赖dic
def get_rely_dic():
    f = open('../project_rely.config', 'r')
    dic = dict(line.strip().split(":") for line in f.readlines())
    f.close()
    return dic


# 校验配置文件
def validate_config():
    for k in relay_config.keys():
        if k not in jobs.keys():
            raise Exception("config error: " + k + "not exist")


if __name__ == '__main__':
    py_path = os.path.split(os.path.realpath(__file__))[0]
    generate_suffix = "_auto_generate_rely"
    rely_dir = "rely_jobs"
    relay_config = get_rely_dic()
    jobs = list_job_paths(py_path + os.sep + "..")
    validate_config()
    generate_jobs_rely(py_path + os.sep + ".." + os.sep + rely_dir)
    update_job_dependencies()
