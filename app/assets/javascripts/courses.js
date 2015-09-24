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
     /* edit stuff */
     if ($("body").hasClass("c_courses")) {  
	 if ( $("body").hasClass("a_edit")) {
	     $("#reorder_btn").on("click", submit_reorder);
	     $("ul.chk_grp").dragsort({dragSelector: "li", dragBetween: true,
				   dragEnd: saveOrder,
				   placeHolderTemplate: "<li class='placeHolder'></li>"
				  });
	 }
	 else if ($("body").hasClass("a_show")) {
/*	     $("button.sort").on("click", function(e) {sortByType($(this))}); */
	 }
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
