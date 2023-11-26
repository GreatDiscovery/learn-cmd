### go项目用到的命令

| 作用             | 命名                                                               | 备注                                                |
|----------------|------------------------------------------------------------------|---------------------------------------------------|
| go查看某个版本依赖     | go mod why -m golang.org/x/net                                   |                                                   |
| go查看某个依赖的所有版本  | go list -m -versions github.com/gin-gonic                        |                                                   |
| 打印依赖图          | go mod graph                                                     | /Users/jiayun/go/bin/gmchart                      |    |
| golang配置私有仓库地址 | [网址](https://blog.csdn.net/senlin1202/article/details/127126946) | 关键是用ssh替换https拉取代码 ，然后用git config --global -e进行替换 |
|                |                                                                  |                                                   |
