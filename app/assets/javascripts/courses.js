/*
 *  Javascripting used for supporting the checkbox groups with select all
 * Bobbi Fox 13 July 2015
 *  support re-ordering
 *  support previous
 *
 */

/*
 *
 *     SELECT FUNCTIONALITY
 *
*/


function allSelected($this, type) {
    if ($this.prop('checked')) {
	globalSelect(true, type);
	$("#deselect_all_" + type).prop("checked", false);
    }
}

function allDeSelected($this, type) {
    if ($this.prop('checked')) {
        globalSelect(false, type);
	$("#select_all_" + type).prop("checked", false);
    }
} 

function allIndividBoxes(type, check_status) {
    $("ul#ids_" + type + " li  input[type='checkbox']").not("#select_all_" + type).prop("checked", check_status);
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
function checkBoxChecked($this, type) {
    if ($this.prop('checked')) {
	enableDisable(type + "_btn", true);
	dragsort(false);
	$("#deselect_all_"  + type).prop("checked", false);
    }
    else {
	$("#select_all_" + type).prop("checked", false);
	if (!anyChecked(type)) {
	    enableDisable(type + "_btn", false);
	    if (type === "del") {
		dragsort(true);
	    }
	} 
    }
}
function enableDisable(name, enable) {
    $this = $("#"+name);
    $this.toggleClass("btn-disabled", !enable);
    $this.toggleClass("btn-submit", enable);
}
/* this is for disabling deletion when there's re-ordering going on */

function enableDisableDelBoxes(status) {
    $("ul#ids_del li input[type='checkbox']").prop('disabled', status); 
    $("#select_all_del").prop('disabled',status);
    $("#deselect_all_del").prop('disabled',status);
    $("label[for='select_all_del']").css("opacity", (status?".5":"1"));
    $("label[for='deselect_all_del']").css("opacity", (status?".5":"1"));
}

/* this is called by both 'select all' and 'deselect all' */
function globalSelect(selected, type) { /* selected is boolean */
    allIndividBoxes(type, selected);
    enableDisable(type + "_btn", selected);
    dragsort(!selected);
}


/* this function is invoked from a <script> element in various erbs */
function checkBoxSetup(type) {
    $("input[type='checkbox']").each(function() { $(this).prop('checked', false);});
    $("ul#ids_" + type + " li  input[type='checkbox']")
	.not("#select_all_" + type)
        .not("#deselect_all_" + type)
	.on("click",{name: type}, function(event) {
	    checkBoxChecked($(this),event.data.name);});
    $("#select_all_" + type).on("click", {name: type}, function(event) {
	allSelected( $(this), event.data.name); });
    $("#deselect_all_" + type).on("click", {name: type}, function(event) {
	allDeSelected( $(this), event.data.name); });
}



/* 
 *
 *  javascripting supporting re-ordering of reserves 
 *
*/
   
function saveOrder() {
    var data = $("#ids_del li").map(function() { 
	return $(this).attr('id'); })
    .get();
    $("#sort_order").val(data.join("|"));
    enableDisable("reorder_btn", true);
    enableDisable("restore_btn", true);
    enableDisableDelBoxes(true);
}

function reordered() {     /* has any reordering occurred? */
    return ($("#sort_order").val() !== "");
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
    dragsort(true);
/*        $("#conf_del").modal("show");  */

}

/* dragsort setup */
function dragsort(enable) {
    if (enable) {
	 $("ul.chk_grp").dragsort({dragSelector: "li", dragBetween: true,
                              dragSelectorExclude: "span.view, span.edit, span.required, span.nomove, input",
                              dragEnd: saveOrder,
                               placeHolderTemplate: "<li class='placeHolder'></li>"
				  });
	 $(".fa-arrows").css("opacity", "1");
    }
    else {
	 $("ul.chk_grp").dragsort("destroy");
	 $(".fa-arrows").css("opacity", ".5");
    }
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
	    $("#select_all_reuse").focus();
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
