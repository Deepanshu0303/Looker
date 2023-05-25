looker.plugins.visualizations.add({
  create: function(element, config) {
    element.innerHTML = `
      <div class="scorecard">
        <div class="total-customers"></div>
        <div class="customer-details">
          <div class="detail">
            <div class="label">Male Customers</div>
            <div class="value"></div>
          </div>
          <div class="detail">
            <div class="label">Female Customers</div>
            <div class="value"></div>
          </div>
        </div>
      </div>
    `;
  },

  updateAsync: function(data, element, config, queryResponse, details, done) {
    var totalCustomers = data[0]["Total_customers"].value;
    var totalMaleCustomers = data[0]["total_male_customers"].value;
    var totalFemaleCustomers = data[0]["total_female_customers"].value;

    element.querySelector(".total-customers").textContent = totalCustomers;
    element.querySelector(".customer-details .value:nth-of-type(1)").textContent = totalMaleCustomers;
    element.querySelector(".customer-details .value:nth-of-type(2)").textContent = totalFemaleCustomers;

    done();
  }
});
