var nostalgic = [];

nostalgic.remove_row = function(trigger) {
  var tr = $(trigger).closest('tr');
  tr.find('input[name*="\[_destroy\]"]').val(true);
  tr.hide();
};

nostalgic.edit_nostalgic_attr = function(trigger) {
  var table = $(trigger).closest('table');

  table.find('tbody').toggle();
  if (table.find('tbody').is(':visible')) {
    $(trigger).siblings().show();
    hyacc.init_datepicker_within(table);
  } else {
    $(trigger).siblings().hide();
  }
};
