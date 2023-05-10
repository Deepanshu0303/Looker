# The name of this view in Looker is "Territories2"
view: territories2 {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `Sales_dataset.territories2`
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Continent" in Explore.

  dimension: continent {
    type: string
    map_layer_name: Continents
    sql: ${TABLE}.Continent ;;
    link: {
      label: "Country Wise Explore"
      #url: "https://streamvector.cloud.looker.com/dashboards/121?Continent={{value}}"
      url:"https://streamvector.cloud.looker.com/dashboards/121?Continent={{value}}&Select+KPI={{_filter['sales.Select_KPI']| url_encode}}"
      #url: "https://streamvector.cloud.looker.com/dashboards/121?Continent={{value}}&Select_KPI={{_filter['sales.Select_KPI']| url_encode}}"
      #url:"https://streamvector.cloud.looker.com/dashboards/121?Continent={{value}}&Select+KPI={{_filter['sales.Select_KPI']| url_encode}}"
      #url: "https://streamvector.cloud.looker.com/dashboards/121?Continent={{value}}&Select+KPI={{_filter['sales.Select_KPI']| url_encode}}"
    }
    drill_fields: [country]
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.Country ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.Region ;;
  }

  dimension: sales_territory_key {
   type: number
    sql: ${TABLE}.SalesTerritoryKey ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_sales_territory_key {
    type: sum
    sql: ${sales_territory_key} ;;
  }

  measure: average_sales_territory_key {
    type: average
    sql: ${sales_territory_key} ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
