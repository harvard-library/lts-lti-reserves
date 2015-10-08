$.extend({ keys: function(obj){ if (typeof Object.keys == 'function') return Object.keys(obj);
				var a = [];
				$.each(obj, function(k){ a.push(k) });
				return a;
			      }
});

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
			$("div.reserve_input_hollis_system_number .col-sm-9").append("<input type='button' class='btn btn-default btn-ajax nonjournal' value='Autofill' name='hollis_fill' id='hollis_fill'/>");
			$("#hollis_fill").on("click", function(e){
			    fill_hollis(e, $("#reserve_input_hollis_system_number").val());
			    });
			$("div.reserve_input_doi .col-sm-9").append("<input type='button' class='btn btn-default btn-ajax journal' value='Autofill' name='article_fill' id='article_fill'/>");
		        $("#article_fill").on("click", function(e){
                            fill_article(e, $("#reserve_input_doi").val());
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

/*
 **  CREATION FUNCTION(S) 
*/

function fill_hollis(e, id) {
    e.preventDefault();
    if (typeof id === "undefined") {
        console.log("No hollis number!");
    }
    else {
	auto_fill("hollis", id)
    }
}
function fill_article(e, id) {
    e.preventDefault();
    if (typeof id === "undefined") {
        console.log("No DOI or PUBMED number!");
    }
    else {
        auto_fill("journal", id)
    }
}

function auto_fill(type,id) {
    $.getJSON('/presto/' + type + '?id=' + encodeURIComponent(id))
	.done(function(data, status, jqXHR) {
            if (data) {
		if (data.status === 200) {
		   var list = $('#switchable :input')
			.not(':button, :submit, :reset, :hidden, :radio, :checkbox');
		    $('#switchable :input')
			.not(':button, :submit, :reset, :hidden, :radio, :checkbox')
			.val('');  /* clear the inputs */
		    $.each($.keys(data), function(i, v) {
			if (v !== "status") {
			    $("#"+v).val(data[v]);
			}
		    });
		    if ($("#reserve_input_doi").val() == '') {
			$("#reserve_input_doi").val(id);
		    }
		}
	    }
	    else {
	    }
	} )
	.fail(function(data, status,jqXHR) {
	    console.log("YOU LOSE!");
	});
}

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


/*
 **  EDIT FUNCTIONS
*/
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


