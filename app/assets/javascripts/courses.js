/*
 *  Javascripting used for supporting the checkbox groups with select all
 * Bobbi Fox 13 July 2015
 *  support re-ordering
 *  support previous
 *
 */


function checkBoxSetup(type) {
    $("ul#ids_" + type + " li > input[type='checkbox']")
	.not("#select_all_" + type)
	.on("click",{name: type}, function(event) {
	    checkBoxChecked($(this),event.data.name);});
    $("#select_all_" + type).on("click", {name: type}, function(event) {
	allSelected( $(this), event.data.name); });
}

function allSelected($this, type) {
    if ($this.prop('checked')) {
	 $("ul#ids_" + type + " li > input[type='checkbox']").not("#select_all_" + type).prop("checked", true);
/*	$(".chks_submit_" + type ).prop("disabled", false); */
    }
}
function checkBoxChecked($this, type) {
    if ($this.prop('checked')) {
/*	$(".chks_submit_" + type).prop("disabled", false); */
    }
    else {
	$("#select_all_" + type).prop("checked", false);
/*	if (!anyChecked(type)) {
	     $(".chks_submit_" + type).prop("disabled", true);
	} */
    }
}
function anyChecked(type) {
    var retVal = false;
    $("ul#ids_" + type + " li > input[type='checkbox']")
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
}

function submit_reorder() { 
/*    console.log($("#form_reorder")); */
   $("#form_reorder").submit();
}

 $(document).on("ready page:load", function(e) {
     if ($("body").hasClass("c_courses") && 
	 $("body").hasClass("a_show")) {
	 $("#reorder_btn").on("click", submit_reorder);
	 $("ul.chk_grp").dragsort({dragSelector: "li", dragBetween: true,
				   dragEnd: saveOrder,
				   placeHolderTemplate: "<li class='placeHolder'></li>"
				  });
		     }
 });

/* handle reuse */
function reuseSetup() {
    $("#prev_select").on("change", displayPrev);
}
function displayPrev() {
    $("#reuse_list").empty();
    var val = this.value;
    if (val !== "") {
	$.get("/courses/previous",
	      { id: val})
	.done(function(data,status,jqXHR) {
	    $("#reuse_list").append(data);
	});
	}
};

