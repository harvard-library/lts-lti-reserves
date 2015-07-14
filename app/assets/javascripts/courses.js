/*
 *  Javascripting used for supporting the checkbox groups with select all
 * Bobbi Fox 13 July 2015
 *
 */


function checkBoxSetup() {
    $("ul.chk_grp li > input[type='checkbox']").not("#select_all").on("click", checkBoxChecked);
    $("#select_all").on("click", allSelected);
}

function allSelected() {
    if ($(this).prop('checked')) {
	 $("ul.chk_grp li > input[type='checkbox']").not("#select_all").prop("checked", true);
	$(".chks_submit").prop("disabled", false);
    }
}
function checkBoxChecked() {
    var $this = $(this);
    if ($this.prop('checked')) {
	$(".chks_submit").prop("disabled", false);
    }
    else {
	$("#select_all").prop("checked", false);
	if (!anyChecked()) {
	     $(".chks_submit").prop("disabled", true);
	}
    }
}
function anyChecked() {
    var retVal = false;
    $("ul.chk_grp li > input[type='checkbox']")
	.not("#select_all")
	.each(function() {
	    if ($(this).prop("checked")) {
		retVal = true;
		return false;
	    }
	});
    return retVal;
}
