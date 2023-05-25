# The name of this view in Looker is "Product Subcategory"
view: product_subcategory {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `Sales_dataset.Product subcategory`
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Product Category Key" in Explore.

  dimension: product_category_key {
    primary_key: yes
    type: number
    sql: ${TABLE}.ProductCategoryKey ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_product_category_key {
    type: sum
    sql: ${product_category_key} ;;
  }

  measure: average_product_category_key {
    type: average
    sql: ${product_category_key} ;;
  }

  dimension: product_subcategory_key {
    type: number
    sql: ${TABLE}.ProductSubcategoryKey ;;
  }

  dimension: subcategory_name {
    type: string
    sql: ${TABLE}.SubcategoryName ;;
    link: {
      label: "Product wise explore"
      url: "https://streamvector.cloud.looker.com/dashboards/125?Subcategory+Name={{value}}&Category+Name={{_filters['product_category.category_name'] | url_encode}}"

    }
  }

  dimension: subcategory_name2 {
    label: "Subcategory Name"
    type: string
    sql: ${TABLE}.SubcategoryName ;;
    link: {
      label: "Product wise explore"
      url: "https://streamvector.cloud.looker.com/dashboards/125?Subcategory+Name={{value}}&Category+Name={{_filters['product_category.category_name'] | url_encode}}"

    }
  }

  measure: count {
    type: count
    drill_fields: [subcategory_name]
  }
}
