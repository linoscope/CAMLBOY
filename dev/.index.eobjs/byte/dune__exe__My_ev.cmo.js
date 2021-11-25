(function(joo_global_object)
   {"use strict";
    var
     runtime=joo_global_object.jsoo_runtime,
     caml_string_of_jsbytes=runtime.caml_string_of_jsbytes;
    function caml_call2(f,a0,a1)
     {return f.length == 2?f(a0,a1):runtime.caml_call_gen(f,[a0,a1])}
    var
     global_data=runtime.caml_get_global_data(),
     cst_metaKey=caml_string_of_jsbytes("metaKey"),
     cst_shiftKey=caml_string_of_jsbytes("shiftKey"),
     cst_ctrlKey=caml_string_of_jsbytes("ctrlKey"),
     cst_altKey=caml_string_of_jsbytes("altKey"),
     cst_screenY=caml_string_of_jsbytes("screenY"),
     cst_screenX=caml_string_of_jsbytes("screenX"),
     cst_pageY=caml_string_of_jsbytes("pageY"),
     cst_pageX=caml_string_of_jsbytes("pageX"),
     cst_clientY=caml_string_of_jsbytes("clientY"),
     cst_clientX=caml_string_of_jsbytes("clientX"),
     cst_identifier=caml_string_of_jsbytes("identifier"),
     Jv=global_data.Jv,
     touchstart="touchstart",
     touchend="touchend";
    function identifier(m){return caml_call2(Jv[20][2],m,cst_identifier)}
    function client_x(m){return caml_call2(Jv[21][2],m,cst_clientX)}
    function client_y(m){return caml_call2(Jv[21][2],m,cst_clientY)}
    function page_x(m){return caml_call2(Jv[21][2],m,cst_pageX)}
    function page_y(m){return caml_call2(Jv[21][2],m,cst_pageY)}
    function screen_x(m){return caml_call2(Jv[21][2],m,cst_screenX)}
    function screen_y(m){return caml_call2(Jv[21][2],m,cst_screenY)}
    var
     Touch=
      [0,identifier,client_x,client_y,page_x,page_y,screen_x,screen_y];
    function alt_key(m){return caml_call2(Jv[19][2],m,cst_altKey)}
    function ctrl_key(m){return caml_call2(Jv[19][2],m,cst_ctrlKey)}
    function shift_key(m){return caml_call2(Jv[19][2],m,cst_shiftKey)}
    function meta_key(m){return caml_call2(Jv[19][2],m,cst_metaKey)}
    var
     Touch$0=[0,Touch,alt_key,ctrl_key,shift_key,meta_key],
     Dune_exe_My_ev=[0,Touch$0,touchstart,touchend];
    runtime.caml_register_global(14,Dune_exe_My_ev,"Dune__exe__My_ev");
    return}
  (function(){return this}()));

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLjAsImZpbGUiOiIuaW5kZXguZW9ianMvYnl0ZS9kdW5lX19leGVfX015X2V2LmNtby5qcyIsInNvdXJjZVJvb3QiOiIiLCJuYW1lcyI6WyJ0b3VjaHN0YXJ0IiwidG91Y2hlbmQiLCJpZGVudGlmaWVyIiwibSIsImNsaWVudF94IiwiY2xpZW50X3kiLCJwYWdlX3giLCJwYWdlX3kiLCJzY3JlZW5feCIsInNjcmVlbl95IiwiYWx0X2tleSIsImN0cmxfa2V5Iiwic2hpZnRfa2V5IiwibWV0YV9rZXkiXSwic291cmNlcyI6WyIvaG9tZS9ydW5uZXIvd29yay9DQU1MQk9ZL0NBTUxCT1kvX2J1aWxkLWRldi9kZWZhdWx0L2Jpbi93ZWIvbXlfZXYubWwiXSwibWFwcGluZ3MiOiI7O0k7Ozs7O0lBRWdDOzs7Ozs7Ozs7Ozs7Ozs7S0FDRjthQU10QkUsV0FBV0MsR0FBSSw0QkFBSkEsaUJBQTZCO0lBTmxCLFNBT3RCQyxTQUFTRCxHQUFJLDRCQUFKQSxjQUE0QjtJQVBmLFNBUXRCRSxTQUFTRixHQUFJLDRCQUFKQSxjQUE0QjtJQVJmLFNBU3RCRyxPQUFPSCxHQUFJLDRCQUFKQSxZQUEwQjtJQVRYLFNBVXRCSSxPQUFPSixHQUFJLDRCQUFKQSxZQUEwQjtJQVZYLFNBV3RCSyxTQUFTTCxHQUFJLDRCQUFKQSxjQUE0QjtJQVhmLFNBWXRCTSxTQUFTTixHQUFJLDRCQUFKQSxjQUE0QjtJQVpmOztTQU10QkQsV0FDQUUsU0FDQUMsU0FDQUMsT0FDQUMsT0FDQUMsU0FDQUM7SUFac0IsU0FjeEJDLFFBQVFQLEdBQUksNEJBQUpBLGFBQTBCO0lBZFYsU0FleEJRLFNBQVNSLEdBQUksNEJBQUpBLGNBQTJCO0lBZlosU0FnQnhCUyxVQUFVVCxHQUFJLDRCQUFKQSxlQUE0QjtJQWhCZCxTQWlCeEJVLFNBQVNWLEdBQUksNEJBQUpBLGNBQTJCO0lBakJaO3NCQWN4Qk8sUUFDQUMsU0FDQUMsVUFDQUM7S0FqQndCLDBCQUQxQmIsV0FDQUM7SUFBMEI7VSIsInNvdXJjZXNDb250ZW50IjpbIm9wZW4gQnJyXG5cbmxldCB0b3VjaHN0YXJ0ID0gRXYuVHlwZS5jcmVhdGUgKEpzdHIudiBcInRvdWNoc3RhcnRcIilcbmxldCB0b3VjaGVuZCA9IEV2LlR5cGUuY3JlYXRlIChKc3RyLnYgXCJ0b3VjaGVuZFwiKVxuXG5tb2R1bGUgVG91Y2ggPSBzdHJ1Y3RcbiAgdHlwZSB0ID0gSnYudFxuICBtb2R1bGUgVG91Y2gnID0gc3RydWN0XG4gICAgdHlwZSB0ID0gSnYudFxuICAgIGxldCBpZGVudGlmaWVyIG0gPSBKdi5JbnQuZ2V0IG0gXCJpZGVudGlmaWVyXCJcbiAgICBsZXQgY2xpZW50X3ggbSA9IEp2LkZsb2F0LmdldCBtIFwiY2xpZW50WFwiXG4gICAgbGV0IGNsaWVudF95IG0gPSBKdi5GbG9hdC5nZXQgbSBcImNsaWVudFlcIlxuICAgIGxldCBwYWdlX3ggbSA9IEp2LkZsb2F0LmdldCBtIFwicGFnZVhcIlxuICAgIGxldCBwYWdlX3kgbSA9IEp2LkZsb2F0LmdldCBtIFwicGFnZVlcIlxuICAgIGxldCBzY3JlZW5feCBtID0gSnYuRmxvYXQuZ2V0IG0gXCJzY3JlZW5YXCJcbiAgICBsZXQgc2NyZWVuX3kgbSA9IEp2LkZsb2F0LmdldCBtIFwic2NyZWVuWVwiXG4gIGVuZFxuICBsZXQgYWx0X2tleSBtID0gSnYuQm9vbC5nZXQgbSBcImFsdEtleVwiXG4gIGxldCBjdHJsX2tleSBtID0gSnYuQm9vbC5nZXQgbSBcImN0cmxLZXlcIlxuICBsZXQgc2hpZnRfa2V5IG0gPSBKdi5Cb29sLmdldCBtIFwic2hpZnRLZXlcIlxuICBsZXQgbWV0YV9rZXkgbSA9IEp2LkJvb2wuZ2V0IG0gXCJtZXRhS2V5XCJcbmVuZFxuIl19
