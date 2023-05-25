view: top5_customers {
  derived_table: {
    sql: WITH customer_sales AS (
        SELECT
          c.CustomerKey,C.FirstName,C.LastName,
          SUM(p.OrderQuantity * pr.ProductPrice) AS TotalSales,
          RANK() OVER (ORDER BY SUM(p.OrderQuantity * pr.ProductPrice) DESC) AS SalesRank
        FROM
          Sales p
        INNER JOIN
          Products pr ON p.ProductKey = pr.ProductKey
        INNER JOIN
          Customers c ON p.CustomerKey = c.CustomerKey
        GROUP BY
           c.CustomerKey,C.FirstName,C.LastName
      )
      SELECT
        SalesRank,CustomerKey,FirstName,LastName,
        TotalSales
      FROM
        customer_sales
      WHERE
        SalesRank <= 5
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

  dimension: first_name {
    type: string
    sql: ${TABLE}.FirstName ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.LastName ;;
  }

  dimension: total_sales {
    type: number
    sql: ${TABLE}.TotalSales ;;
  }

  set: detail {
    fields: [sales_rank, customer_key, first_name, last_name, total_sales]
  }
}
