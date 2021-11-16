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

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLjAsImZpbGUiOiIuaW5kZXguZW9ianMvYnl0ZS9kdW5lX19leGVfX015X2V2LmNtby5qcyIsInNvdXJjZVJvb3QiOiIiLCJuYW1lcyI6WyJ0b3VjaHN0YXJ0IiwidG91Y2hlbmQiLCJpZGVudGlmaWVyIiwibSIsImNsaWVudF94IiwiY2xpZW50X3kiLCJwYWdlX3giLCJwYWdlX3kiLCJzY3JlZW5feCIsInNjcmVlbl95IiwiYWx0X2tleSIsImN0cmxfa2V5Iiwic2hpZnRfa2V5IiwibWV0YV9rZXkiXSwic291cmNlcyI6WyIvaG9tZS9ydW5uZXIvd29yay9DQU1MQk9ZL0NBTUxCT1kvX2J1aWxkL2RlZmF1bHQvYmluL3dlYi9teV9ldi5tbCJdLCJtYXBwaW5ncyI6Ijs7STs7Ozs7SUFFZ0M7Ozs7Ozs7Ozs7Ozs7OztLQUNGO2FBTXRCRSxXQUFXQyxHQUFJLDRCQUFKQSxpQkFBNkI7SUFObEIsU0FPdEJDLFNBQVNELEdBQUksNEJBQUpBLGNBQTRCO0lBUGYsU0FRdEJFLFNBQVNGLEdBQUksNEJBQUpBLGNBQTRCO0lBUmYsU0FTdEJHLE9BQU9ILEdBQUksNEJBQUpBLFlBQTBCO0lBVFgsU0FVdEJJLE9BQU9KLEdBQUksNEJBQUpBLFlBQTBCO0lBVlgsU0FXdEJLLFNBQVNMLEdBQUksNEJBQUpBLGNBQTRCO0lBWGYsU0FZdEJNLFNBQVNOLEdBQUksNEJBQUpBLGNBQTRCO0lBWmY7O1NBTXRCRCxXQUNBRSxTQUNBQyxTQUNBQyxPQUNBQyxPQUNBQyxTQUNBQztJQVpzQixTQWN4QkMsUUFBUVAsR0FBSSw0QkFBSkEsYUFBMEI7SUFkVixTQWV4QlEsU0FBU1IsR0FBSSw0QkFBSkEsY0FBMkI7SUFmWixTQWdCeEJTLFVBQVVULEdBQUksNEJBQUpBLGVBQTRCO0lBaEJkLFNBaUJ4QlUsU0FBU1YsR0FBSSw0QkFBSkEsY0FBMkI7SUFqQlo7c0JBY3hCTyxRQUNBQyxTQUNBQyxVQUNBQztLQWpCd0IsMEJBRDFCYixXQUNBQztJQUEwQjtVIiwic291cmNlc0NvbnRlbnQiOlsib3BlbiBCcnJcblxubGV0IHRvdWNoc3RhcnQgPSBFdi5UeXBlLmNyZWF0ZSAoSnN0ci52IFwidG91Y2hzdGFydFwiKVxubGV0IHRvdWNoZW5kID0gRXYuVHlwZS5jcmVhdGUgKEpzdHIudiBcInRvdWNoZW5kXCIpXG5cbm1vZHVsZSBUb3VjaCA9IHN0cnVjdFxuICB0eXBlIHQgPSBKdi50XG4gIG1vZHVsZSBUb3VjaCcgPSBzdHJ1Y3RcbiAgICB0eXBlIHQgPSBKdi50XG4gICAgbGV0IGlkZW50aWZpZXIgbSA9IEp2LkludC5nZXQgbSBcImlkZW50aWZpZXJcIlxuICAgIGxldCBjbGllbnRfeCBtID0gSnYuRmxvYXQuZ2V0IG0gXCJjbGllbnRYXCJcbiAgICBsZXQgY2xpZW50X3kgbSA9IEp2LkZsb2F0LmdldCBtIFwiY2xpZW50WVwiXG4gICAgbGV0IHBhZ2VfeCBtID0gSnYuRmxvYXQuZ2V0IG0gXCJwYWdlWFwiXG4gICAgbGV0IHBhZ2VfeSBtID0gSnYuRmxvYXQuZ2V0IG0gXCJwYWdlWVwiXG4gICAgbGV0IHNjcmVlbl94IG0gPSBKdi5GbG9hdC5nZXQgbSBcInNjcmVlblhcIlxuICAgIGxldCBzY3JlZW5feSBtID0gSnYuRmxvYXQuZ2V0IG0gXCJzY3JlZW5ZXCJcbiAgZW5kXG4gIGxldCBhbHRfa2V5IG0gPSBKdi5Cb29sLmdldCBtIFwiYWx0S2V5XCJcbiAgbGV0IGN0cmxfa2V5IG0gPSBKdi5Cb29sLmdldCBtIFwiY3RybEtleVwiXG4gIGxldCBzaGlmdF9rZXkgbSA9IEp2LkJvb2wuZ2V0IG0gXCJzaGlmdEtleVwiXG4gIGxldCBtZXRhX2tleSBtID0gSnYuQm9vbC5nZXQgbSBcIm1ldGFLZXlcIlxuZW5kXG4iXX0=
