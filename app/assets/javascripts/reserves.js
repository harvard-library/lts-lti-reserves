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
			onReadyCreate();

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
 **  CREATION/RESET FUNCTION(S) 
*/

/* this is called to address my being too clever with input_year */
function submitting_create() {
    var years = $("input[name='reserve[input_year]']");
    if (years.length > 1) {
	var y = "";
	years.each(function(i) {
	    if ($(this).val() != "") {
		y = $(this).val();
	    }
	});
	if (y !== "") {
	    years.each(function(i) {
		$(this).val(y);
	    });
	}
    }
    $("#new_reserve").submit();
}

function fill_hollis(e, id) {
    e.preventDefault();
    if (typeof id === "undefined") {
	$("#reset_hollis_fill").addClass("disabled");
    }
    else {
	auto_fill("hollis", id)
	$("#reset_hollis_fill").removeClass("disabled");
    }
}
function fill_article(e, id) {
    e.preventDefault();
    if (typeof id === "undefined") {
	$("#reset_article_fill").addClass("disabled");
    }
    else {
        auto_fill("journal", id)
	 $("#reset_article_fill").removeClass("disabled");
    }
}

function auto_fill(type,id) {
    $.getJSON('/presto/' + type + '?id=' + encodeURIComponent(id))
	.done(function(data, status, jqXHR) {
            if (data) {
		if (data.status === 200) {
		   var list = $('#switchable :input')
			.not(':button, :submit, :reset, :hidden, :radio, :checkbox');
		    switchable_reset();
		    $.each($.keys(data), function(i, v) {
			if (v !== "status") {
			    $("#"+v).val(data[v].substr(0, $("#"+v).prop("maxlength")));
			}
		    });
		    if (type === "journal") {
			if ($("#reserve_input_doi").val() == '') {
			    $("#reserve_input_doi").val(id);
			}
			$("#reserve_input_article_title").focus();
		    }
		    else {
			$("#reserve_input_title").focus();
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

function switchable_reset() { /* clear the inputs */
    $('#switchable :input')
        .not(':button, :submit, :reset, :radio, :checkbox')
        .val('');  
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
     $(".auto").hide();
     if (type === "JOURNAL") {
	 $(".auto_nj").hide();
	 $(".nonjournal").hide();
	  if ($("#reserve_input_hollis_system_number").val() !== "") {
                    switchable_reset();
          }
	 $(".journal").show();
	 $(".auto_j").show();
     }
     else if (type === "NON_JOURNAL") {
	 $(".journal").hide();
	 $(".auto_j").hide();
         if ($("#reserve_input_doi").val() !== "") {
             switchable_reset();
         }
	 $(".nonjournal").show();
	 $(".auto_nj").show();
     }
     else { return; }
     $(".both").show();
     $("#switchable").show();
 }

function disable_auto(clicker_id) {
    if ($(this).val() !== "") {
        $("#" + clicker_id).removeClass("disabled");
    }
    else {
	$("#" + clicker_id).addClass("disabled");
	$("#reset_" + clicker_id).addClass("disabled");
    }
}

/*  treats the Enter key as if it's a click of the associated button */
function inhibit_submit(input_id, clicker_id) {
    $("#"+input_id).keypress(function(e) {
	var key = e.which;
	if (key == 13) {
	    $("#" + clicker_id).click();
	    return false;
	}
    });
}

/*
 **  ONREADY FUNCTIONS
*/

function onReadyCreate() {
    $("#submit_create").on("click", submitting_create);
    setupDatepicker($("#reserve_lecture_date"), $("#iso_date"));
    material_type_change($("#reserve_input_material_type")); /* when we come back with an error */
    $("#reserve_input_material_type").on("change", function(e) {
	material_type_change($(this));
    });
    /* handle non-journal reserve */
    $("div.reserve_input_hollis_system_number .col-sm-9")
	.append("<p class='help-block auto auto_nj'>Minimum: HOLLIS number OR Title OR URL; use HOLLIS number to autofill</p>")
	.append("<input type='button' class='btn btn-default btn-ajax nonjournal' value='Autofill from the HOLLIS number' name='hollis_fill' id='hollis_fill'/>")
	.append("<input type='button' class='btn btn-default btn-ajax nonjournal reset_fill' value='Reset Autofill' name='reset_hollis_fill' id='reset_hollis_fill'/>");
    $("#hollis_fill").on("click", function(e){
	fill_hollis(e, $("#reserve_input_hollis_system_number").val());
    });
    inhibit_submit("reserve_input_hollis_system_number","hollis_fill");
/*			$("#reserve_input_hollis_system_number").change(disable_auto("hollis_fill")); */

    /* journal */
    $("div.reserve_input_doi .col-sm-9")
	.append("<p class='help-block auto auto_j'>Minimum: Article Title AND Journal Title OR URL; enter a DOI/PUBMED ID to autofill</p>")
	.append("<input type='button' class='btn btn-default btn-ajax journal' value='Autofill from DOI or PUBMED ID' name='article_fill' id='article_fill'/>")
	.append("<input type='button' class='btn btn-default btn-ajax journal reset_fill' value='Reset Autofill' name='article_fill' id='reset_article_fill'/>") ;
    $("#article_fill").on("click", function(e){
        fill_article(e, $("#reserve_input_doi").val());
    });
    inhibit_submit("reserve_input_doi", "article_fill");
    $(".reset_fill").on("click", function(e){
	switchable_reset();
	if ($(this).hasClass("journal")) {
	    $("#reserve_input_article_title").focus();
	}
	else {
	    $("#reserve_input_title").focus();
	}
    });


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


