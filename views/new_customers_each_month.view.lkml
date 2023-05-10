view: new_customers_each_month {
  derived_table: {
    sql: With temp as (select CustomerKey, min(orderdate) as FirstOrderDate
      from Sales S
      group by CustomerKey)

      select FORMAT_DATE('%Y-%m', FirstOrderDate) AS month, count(*) as New_Customers
      from (select CustomerKey, min(OrderDate) as FirstOrderDate
      from  Sales S
      group by CustomerKey
      ) oc
      group by month
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: month {
    type: string
    sql: ${TABLE}.month ;;
  }

  dimension: new_customers {
    type: number
    sql: ${TABLE}.New_Customers ;;
  }

  set: detail {
    fields: [month, new_customers]
  }
}
