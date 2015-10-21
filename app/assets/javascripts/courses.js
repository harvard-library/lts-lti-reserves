/*
 *  Javascripting used for supporting the checkbox groups with select all
 * Bobbi Fox 13 July 2015
 *  support re-ordering
 *  support previous
 *
 */

/* this function is invoked from a <script> element in various erbs */
function checkBoxSetup(type) {
    $("ul#ids_" + type + " li  input[type='checkbox']")
	.not("#select_all_" + type)
	.on("click",{name: type}, function(event) {
	    checkBoxChecked($(this),event.data.name);});
    $("#select_all_" + type).on("click", {name: type}, function(event) {
	allSelected( $(this), event.data.name); });
}

function enableDisable(name, enable) {
    $this = $("#"+name);
    $this.toggleClass("btn-disabled", !enable);
    $this.toggleClass("btn-submit", enable);
}

function allSelected($this, type) {
    if ($this.prop('checked')) {
	allBoxes(type, true);
	enableDisable(type + "_btn", true);
/*	$(".chks_submit_" + type ).prop("disabled", false); */
    }
}

function enableDisableDelBoxes(status) {
    $("ul#ids_del li input[type='checkbox']").prop('disabled', status); 
    $("#select_all_del").prop('disabled',status);
    $("label[for='select_all_del']").css("opacity", (status?".5":"1"));
}

function allBoxes(type, check_status) {
    $("ul#ids_" + type + " li  input[type='checkbox']").not("#select_all_" + type).prop("checked", check_status);
}
function checkBoxChecked($this, type) {
    if ($this.prop('checked')) {
/*	$(".chks_submit_" + type).prop("disabled", false); */
	enableDisable(type + "_btn", true);
    }
    else {
	$("#select_all_" + type).prop("checked", false);
	if (!anyChecked(type)) {
/*	     $(".chks_submit_" + type).prop("disabled", true); */
	    enableDisable(type + "_btn", false);
	} 
    }
}
function anyChecked(type) {
    var retVal = false;
    $("ul#ids_" + type + " li  input[type='checkbox']")
	.not("#select_all_" + type)
	.each(function() {
	    if ($(this).prop("checked")) {
		retVal = true;
		return false;
	    }
	});
    return retVal;
}

/* javascripting supporting re-ordering of reserves */
function saveOrder() {
    var data = $("#ids_del li").map(function() { 
	return $(this).attr('id'); })
    .get();
    $("#sort_order").val(data.join("|"));
    enableDisable("reorder_btn", true);
    enableDisable("restore_btn", true);
    enableDisableDelBoxes(true);
}

function submit_reorder() { 
/*    console.log($("#form_reorder")); */
    if (reordered()) {
	$("#form_reorder").submit();
    }
    else {return false; } /* no ordering to be had! */
}

function submit_delete() {
    if (anyChecked("del")) {
	$("#form_del").submit();
    }
    else {return false; } /* nothing to be deleted! */
}
function reordered() {     /* has any reordering occurred? */
    return ($("#sort_order").val() !== "");
}

/* set up events */
 $(document).on("ready page:load", function(e) {
     /* edit stuff */
     if ($("body").hasClass("c_courses")) {  
	 if ( $("body").hasClass("a_edit")) {
	     setupEditEvents();
	 }
	 else if ($("body").hasClass("a_show")) {
/*	     $("button.sort").on("click", function(e) {sortByType($(this))}); */
	 }
     }
});

/* setup edit events; I separated this out for clarity */
function setupEditEvents() {
    allBoxes("del", false);
    enableDisableDelBoxes(false);
    $("#reorder_btn").on("click", function(e){
	$("#conf_reord").modal("show");
    });
    $("#del_btn").on("click", function(e) {
	$("#conf_del").modal("show");
    });
    $("#restore_btn").on("click", function(e) {
	location.reload();
    });
    $("#confirmed_del").on("click", submit_delete);
    $("#confirmed_reord").on("click", submit_reorder);
    $("ul.chk_grp").dragsort({dragSelector: "li", dragBetween: true,
			      dragSelectorExclude: "span.view, span.edit, span.required, span.nomove, input",
                              dragEnd: saveOrder,
                               placeHolderTemplate: "<li class='placeHolder'></li>"
			     });
/*        $("#conf_del").modal("show");  */

}


/* handle reuse */
function reuseSetup() {
    $("#prev_select").on("change", displayPrev);
}
function displayPrev() {
    $("#reuse_list").empty();
    var val = this.value;
    if (val !== "") {
	$.get("/courses/previous",
	      { id: $("#id").val(), prev_id: val, course_title: $("#"+this.id + " option:selected").text()})
	.done(function(data,status,jqXHR) {
	    $("#reuse_list").append(data);
	});
	}
};

/* handle sorting. I might have figured this out myself eventually, but
h/t Reto Aebersold
http://stackoverflow.com/users/286432/reto-aebersold 
*/

var sortType = ""

function sortByType($this) {
    sortType = $this.attr("data-sort");
    $("ul#reserves_ids li").sort(sortEm).prependTo("ul#reserves_ids");
    sortType = ""; /* clear the sortType out for next time */
}

function sortEm(a,b){
    if (sortType !== "") {
	var span = "span." + sortType;
	return $(span, a).text() > $(span, b).text() ? 1 : -1;
    }
  return -1; 
}
