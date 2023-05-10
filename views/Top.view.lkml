view: TopNView {
  derived_table: {
    explore_source: sales {
      column: product_brand { field: products.brand }
      column: sale_price {field: order_items.total_sale_price}
      derived_column: brand_rank {
        sql: row_number () over (order by sale_price desc) ;;
      }

    }
  }

  dimension: brand_rank {
    type: number
  }

  dimension: product_brand {
    description:" "
  }

  dimension: sale_price {
    description: ""
    value_format: "S#,##0.00"
    type: number
  }
}
