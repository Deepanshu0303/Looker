view: distribution_customer {
  derived_table: {
    sql: SELECT
        c.CustomerKey,
        g.gender,
        total_customers.TotalCustomers
      FROM
        (SELECT DISTINCT CustomerKey FROM Sales) c
      CROSS JOIN
        (SELECT COUNT(DISTINCT CustomerKey) AS TotalCustomers FROM Sales) total_customers
      LEFT JOIN
        Customers g ON c.CustomerKey = g.CustomerKey
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: customer_key {
    type: number
    sql: ${TABLE}.CustomerKey ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: total_customers {
    type: number
    sql: ${TABLE}.TotalCustomers ;;
  }
  measure: total_female_customers {
    type: count_distinct
    filters: {
      field:gender
      value: "F"
    }
    sql: ${TABLE}.CustomerKey ;;
  }
  measure: total_male_customers {
    type: count_distinct
    filters: {
      field:gender
      value: "M"
    }
    sql: ${TABLE}.CustomerKey ;;
  }

  set: detail {
    fields: [customer_key, gender, total_customers]
  }
}
