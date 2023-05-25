view: new_customers_each_month {
  derived_table: {
    sql: select FORMAT_DATE('%b-%Y', FirstOrderDate) AS month,FORMAT_DATE('%m', FirstOrderDate) AS month_number,EXTRACT(YEAR FROM FirstOrderDate) AS year, count(*) as New_Customers
      from (select CustomerKey, min(OrderDate) as FirstOrderDate
      from  Sales S
      group by CustomerKey
      ) oc
      group by month,month_number,year
      ORDER BY year
      ;;
  }
   #With temp as (select CustomerKey, min(orderdate) as FirstOrderDate
    #  from Sales S
      #group by CustomerKey)
#%Y-%m'
  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: month {
    type: string
    sql: ${TABLE}.month ;;
  }
  dimension: month_number {
    type: number
    sql: ${TABLE}.month_number ;;
  }
  dimension: year {
    type: number
    sql: ${TABLE}.year ;;
  }

  dimension: new_customers {
    type: number
    sql: ${TABLE}.New_Customers ;;
  }

  set: detail {
    fields: [month,month_number,year, new_customers]
  }
}
