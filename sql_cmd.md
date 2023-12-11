### 常用的sql

| 作用          | 命令                                                                                                                  | 备注                 |   
|-------------|---------------------------------------------------------------------------------------------------------------------|--------------------|
| 分组排序后取第一个   | [code](#code1)                                                                                                      | 8.0兼容，部分老版本的5.7不可用 |
| 多行合成一行用逗号分割 | SELECT GROUP_CONCAT(id SEPARATOR ',') FROM redis_cluster  where env = 'test' and deleted_at is null and status = 4; |                    |

#### code1

```sql
select *
from (select row_number()
                 over (partition by colum_partiion order by colum_order desc) as rownum, *
      from (SELECT *
            FROM talbe) as G1) as G
where G.rownum = 1
```