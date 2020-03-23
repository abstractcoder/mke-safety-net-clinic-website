// This is where it all goes :)

var checkboxes = document.querySelectorAll("input[type=checkbox]")
var services = document.querySelector(".services")

var showClinics = function() {
  var ids = null

  for (checkbox of document.querySelectorAll("input[type=checkbox]:checked")) {
    var newIds = JSON.parse(checkbox.value)

    if (ids === null) {
      ids = newIds
    }
    else {
      ids = ids.filter(function(value) { return newIds.indexOf(value) !== -1 })
    }
  }

  for (clinic of document.querySelectorAll("[data-clinic-id]")) {
    var clinicId = clinic.dataset["clinicId"]

    if (ids === null || ids.indexOf(clinicId) > -1) {
      clinic.removeAttribute("hidden")
    }
    else {
      clinic.setAttribute("hidden", true)
    }
  }

  if (ids && ids.length == 0) {
    services.classList.add("empty")
  }
  else {
    services.classList.remove("empty")
  }
}

for (checkbox of checkboxes) {
  checkbox.addEventListener("click", showClinics)
}
