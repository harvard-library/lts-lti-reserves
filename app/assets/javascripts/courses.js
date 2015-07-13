/*
 *  Javascripting used for supporting the Course Controller
 * Bobbi Fox 13 July 2015
 *
 */


function checkBoxSetup() {
    $(".check_delete").on("click", checkBoxChecked);
    $("#select_all").on("click", allSelected);
}

function allSelected() {
    if ($(this).prop('checked')) {
	$(".check_delete").prop("checked", true);
	$("#delete_btn").prop("disabled", false);
    }
}
function checkBoxChecked() {
    var $this = $(this);
    if ($this.prop('checked')) {
	$("#delete_btn").prop("disabled", false);
    }
    else {
	$("#select_all").prop("checked", false);
	if (!anyChecked()) {
	     $("#delete_btn").prop("disabled", true);
	}
    }
}
function anyChecked() {
    var retVal = false;
    $(".check_delete").each(function() {
	if ($(this).prop("checked")) {
	    retVal = true;
	    return false;
	}
    });
    return retVal;
}
