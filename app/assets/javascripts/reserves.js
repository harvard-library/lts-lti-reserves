/* set up a jquery object with the datepicker. if isotarget defined, 
   add the change date event handler for ISO string conversion
*/
  var updates = ["estimated_enrollment", "student_annotation", "lecture_date", "required", "visibility"];

 $(document).on("ready page:load", function(e) {
                 if ($("body").hasClass("c_reserves")) {
		    if ($("body").hasClass("a_edit") ) {
		       setupDatepicker($("#reserve_lecture_date"), $("#iso_date"));
		    }
		    else if ( $("body").hasClass("a_new") ||
			       $("body").hasClass("a_create") ) {
                       setupDatepicker($("#reserve_lecture_date"), $("#iso_date"));
			material_type_change($("#reserve_input_material_type")); /* when we come back with an error */
			$("#reserve_input_material_type").on("change", function(e) {
			    material_type_change($(this));
			});
		    }
		 }
});

  /*   COMMON FUNCTIONS */

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

/* CREATION FUNCTION(S) */

function material_type_change($this) {
    var val = $this.val();
    if (val === "") {
	switch_type("");
    } 
    else {
	var type = ($this.val() === "Journal Article")? "JOURNAL" : "NON_JOURNAL";
	switch_type(type);
    }
    return;
}

/* shows and hides elements according to type */ 
 function switch_type(type) {
     $("#switchable").hide();
     if (type === "JOURNAL") {
	 $(".nonjournal").hide();
	 $(".journal").show();
     }
     else if (type === "NON_JOURNAL") {
	 $(".nonjournal").show();
	 $(".journal").hide();
     }
     else { return; }
     $(".both").show();
     $("#switchable").show();
 }

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


