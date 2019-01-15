## 1. 文件说明
    relay_check.py: azkaban 跨项目依赖检查脚本
    generator.py    azkaban 跨项目依赖代码生成器

## 2. 使用说明

1. 目录结构

        |
        |- generator
        |- <job-dir>
        |- relay_jobs                        自动生成依赖项目文件夹
        |- project_rely.config               跨项目依赖配置文件
2. 跨项目依赖配置example:

        job1:project_name1#flow1#job1
        job2:project_name2#flow2#job2
        job3:project_name3#flow3#job3

3. usage:

        配置完成运行 generator.py 即可.
