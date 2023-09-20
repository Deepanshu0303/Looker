view: top5_customers {
  derived_table: {
    sql: WITH customer_sales AS (
        SELECT
          c.CustomerKey,C.FirstName,C.LastName,concat(C.FirstName," ",C.LastName) as Fullname,
          SUM(p.OrderQuantity * pr.ProductPrice) AS TotalSales,
          RANK() OVER (ORDER BY SUM(p.OrderQuantity * pr.ProductPrice) DESC) AS SalesRank
        FROM
          Sales p
        INNER JOIN
          products pr ON p.ProductKey = pr.ProductKey
        INNER JOIN
          Customers c ON p.CustomerKey = c.CustomerKey
        GROUP BY
           c.CustomerKey,C.FirstName,C.LastName
      )
      SELECT
        SalesRank,CustomerKey,FirstName,LastName,Fullname,
        TotalSales
      FROM
        customer_sales
      WHERE
        SalesRank <= {% parameter top_rank_limit %}
        order by SalesRank ASC
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: sales_rank {
    type: number
    sql: ${TABLE}.SalesRank ;;
  }

  dimension: customer_key {
    type: number
    sql: ${TABLE}.CustomerKey ;;
  }
  parameter: top_rank_limit {
    type: unquoted
    default_value: "5"
    allowed_value: {
      label: "Top 3"
      value: "3"
    }
    allowed_value: {
      label: "Top 5"
      value: "5"
    }
    allowed_value: {
      label: "Top 10"
      value: "10"
    }

  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.FirstName ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.LastName ;;
  }
  dimension: fullname {
    type: string
    sql: ${TABLE}.Fullname ;;
  }

  dimension: total_sales {
    type: number
    sql: ${TABLE}.TotalSales ;;
  }

  set: detail {
    fields: [sales_rank, customer_key, first_name, last_name, fullname,total_sales]
  }
}
