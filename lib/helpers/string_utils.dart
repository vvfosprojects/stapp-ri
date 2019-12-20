String truncateString(String original, int length, {String ellipsis}) {

  assert(original!=null);
  assert(length!=null);

  String _ellipsis = "..."; 
  String truncated;
  int truncateAt = length;

  if(ellipsis != null && ellipsis.isNotEmpty){
    _ellipsis = ellipsis;
  }

  if (original.length > truncateAt) {
    truncated = original.substring(0, truncateAt - _ellipsis.length) + _ellipsis;
  } else {
    truncated = original;
  }
  return truncated ?? "";
}
