/* set up a jquery object with the datepicker. if isotarget defined, 
   add the change date event handler for ISO string conversion
*/
  var updates = ["estimated_enrollment", "student_annotation", "lecture_date", "required", "visibility"];

 $(document).on("ready page:load", function(e) {
                 if ($("body").hasClass("c_reserves")) {
		    if ($("body").hasClass("a_edit")) {
		       setupDatepicker($("#reserve_lecture_date"), $("#iso_date"));
		    }
		 }
});
  function submitUpdate(e) {
      e.preventDefault();
      var change = false;
      for ( i = 0; i < updates.length; i++) {
	    if ($("#o_"+updates[i]).val() !== $("#reserve_" + updates[i]).val()) {
		change = true;
		break;
	  }
      }
      if (!change) {
	  alert("No changes have been made");
	  return false;
      } else {
	  $(this).submit();
      }
}
  function setupDatepicker($which, $isotarget) {
	 $which.datepicker({
                       startDate: "now",
                       endDate: "+365d",
                       clearBtn: true,
                       todayHighlight: true,
                       toggleActive: true,
                       orientation: "top auto"
	});
	if (typeof $isotarget == "object") {
	   $which.datepicker().on("changeDate", function(e) {
	      $isotarget.val(e.date.toISOString());
	   });
	}
  }

