view: new_customers {
  derived_table: {
    sql: (SELECT C.CustomerKey, MIN(S.OrderDate) as Aquisition_date FROM
      my-first-project-2023-376710.Sales_dataset.Sales S
      LEFT JOIN
      my-first-project-2023-376710.Sales_dataset.Customers C
      ON
      S.CustomerKey = C.CustomerKey
      GROUP BY C.CustomerKey
      HAVING MIN(S.OrderDate)>= Date({% parameter parameters.select_reference_date %})
      AND MIN(S.OrderDate)< DATE_TRUNC(DATE_ADD(Date({% parameter parameters.select_reference_date %}), interval 1 month),MONTH))
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: customer_key {
    primary_key: yes
    type: number
    sql: ${TABLE}.CustomerKey ;;
  }
  measure: new_customer_joined {
    type: number
    sql: count(${customer_key}) ;;
  }

  dimension:Aquisition_date  {
    type: date
    datatype: date
    sql: ${TABLE}.Aquisition_date ;;
  }


  set: detail {
    fields: [customer_key,Aquisition_date ]
  }
}
