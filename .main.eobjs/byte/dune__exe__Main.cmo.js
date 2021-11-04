(function(joo_global_object)
   {"use strict";
    var
     runtime=joo_global_object.jsoo_runtime,
     caml_check_bound=runtime.caml_check_bound,
     caml_string_of_jsbytes=runtime.caml_string_of_jsbytes;
    function caml_call1(f,a0)
     {return f.length == 1?f(a0):runtime.caml_call_gen(f,[a0])}
    function caml_call2(f,a0,a1)
     {return f.length == 2?f(a0,a1):runtime.caml_call_gen(f,[a0,a1])}
    function caml_call3(f,a0,a1,a2)
     {return f.length == 3?f(a0,a1,a2):runtime.caml_call_gen(f,[a0,a1,a2])}
    function caml_call4(f,a0,a1,a2,a3)
     {return f.length == 4
              ?f(a0,a1,a2,a3)
              :runtime.caml_call_gen(f,[a0,a1,a2,a3])}
    function caml_call5(f,a0,a1,a2,a3,a4)
     {return f.length == 5
              ?f(a0,a1,a2,a3,a4)
              :runtime.caml_call_gen(f,[a0,a1,a2,a3,a4])}
    var
     global_data=runtime.caml_get_global_data(),
     cst_Load_Rom=caml_string_of_jsbytes("Load Rom"),
     Brr=global_data.Brr,
     Jv=global_data.Jv,
     Stdlib_List=global_data.Stdlib__List,
     Fut=global_data.Fut,
     Camlboy_lib_Detect_cartridge=global_data.Camlboy_lib__Detect_cartridge,
     Camlboy_lib_Camlboy=global_data.Camlboy_lib__Camlboy,
     Brr_canvas=global_data.Brr_canvas,
     Stdlib_Array=global_data.Stdlib__Array,
     gb_w=160,
     gb_h=144;
    function draw_framebuffer(ctx,image_data,fb)
     {var d=caml_call1(Brr_canvas[4][90][4],image_data),y=0;
      a:
      for(;;)
       {var x=0;
        for(;;)
         {var
           off=4 * ((y * 160 | 0) + x | 0) | 0,
           match=caml_check_bound(caml_check_bound(fb,y)[1 + y],x)[1 + x];
          if(-588596599 <= match)
           if(-126317716 <= match)
            {d[off] = 119;
             d[off + 1 | 0] = 119;
             d[off + 2 | 0] = 119;
             d[off + 3 | 0] = 255}
           else
            {d[off] = 255;
             d[off + 1 | 0] = 255;
             d[off + 2 | 0] = 255;
             d[off + 3 | 0] = 255}
          else
           if(-603547828 <= match)
            {d[off] = 170;
             d[off + 1 | 0] = 170;
             d[off + 2 | 0] = 170;
             d[off + 3 | 0] = 255}
           else
            {d[off] = 0;
             d[off + 1 | 0] = 0;
             d[off + 2 | 0] = 0;
             d[off + 3 | 0] = 255}
          var _m_=x + 1 | 0;
          if(159 !== x){var x=_m_;continue}
          var _l_=y + 1 | 0;
          if(143 !== y){var y=_l_;continue a}
          return caml_call4(Brr_canvas[4][93],ctx,image_data,0,0)}}}
    function run_rom(rom_bytes,ctx,image_data)
     {var
       cartridge=caml_call1(Camlboy_lib_Detect_cartridge[1],rom_bytes),
       C=caml_call1(Camlboy_lib_Camlboy[1],cartridge),
       t=caml_call2(C[3],1,rom_bytes),
       cnt=[0,0],
       start_time=[0,caml_call1(Brr[15][9],Brr[16][4])];
      function main_loop(param)
       {for(;;)
         {var match=caml_call1(C[4],t);
          if(match)
           {var fb=match[1];
            cnt[1]++;
            if(60 === cnt[1])
             {var
               end_time=caml_call1(Brr[15][9],Brr[16][4]),
               sec_per_60_frame=(end_time - start_time[1]) / 1000.,
               fps=60. / sec_per_60_frame;
              start_time[1] = end_time;
              caml_call1(Brr[12][9],[0,fps,0]);
              cnt[1] = 0}
            return draw_framebuffer(ctx,image_data,fb)}
          continue}}
      caml_call2(Brr[16][9],1,main_loop);
      return 0}
    function load_rom_button(ctx,image_data)
     {var
       _e_=[0,[0,caml_call1(Brr[8][36],"file"),0]],
       input_el=caml_call3(Brr[9][109],0,_e_,0),
       _f_=[0,caml_call2(Brr[9][3],0,cst_Load_Rom),0],
       button_el=caml_call3(Brr[9][72],0,0,_f_);
      caml_call4(Brr[9][33],0,Brr[9][30][4],"none",input_el);
      function _g_(param){return caml_call1(Brr[9][54],input_el)}
      caml_call4(Brr[7][20],0,Brr[7][44],_g_,button_el);
      function _h_(param)
       {var
         _i_=caml_call1(Brr[9][56][1],input_el),
         file=caml_call1(Stdlib_List[5],_i_),
         buf_fut=caml_call1(Brr[2][8],file);
        function _j_(param)
         {if(0 === param[0])
           {var
             buf=param[1],
             rom_bytes=
              runtime.caml_ba_from_typed_array
               (caml_call4(Brr[1][5],3,0,0,buf));
            return run_rom(rom_bytes,ctx,image_data)}
          var e=param[1],_k_=[0,caml_call1(Jv[30][4],e),0];
          return caml_call1(Brr[12][9],_k_)}
        return caml_call2(Fut[2],buf_fut,_j_)}
      caml_call4(Brr[7][20],0,Brr[7][43],_h_,input_el);
      return caml_call3(Brr[9][144],0,0,[0,input_el,[0,button_el,0]])}
    var
     _a_=[0,[0,caml_call1(Brr[8][24],"screen"),0]],
     cnv=caml_call5(Brr_canvas[3][1],0,_a_,[0,gb_w],[0,gb_h],0),
     ctx=caml_call2(Brr_canvas[4][15],0,cnv),
     image_data=caml_call3(Brr_canvas[4][91],ctx,gb_w,gb_h),
     fb=caml_call3(Stdlib_Array[3],gb_h,gb_w,-126317716);
    draw_framebuffer(ctx,image_data,fb);
    var
     _b_=[0,load_rom_button(ctx,image_data),0],
     _c_=[0,caml_call1(Brr_canvas[3][3],cnv),_b_],
     _d_=caml_call1(Brr[10][5],Brr[16][2]);
    caml_call2(Brr[9][18],_d_,_c_);
    var Dune_exe_Main=[0,gb_w,gb_h,draw_framebuffer,run_rom,load_rom_button];
    runtime.caml_register_global(14,Dune_exe_Main,"Dune__exe__Main");
    return}
  (function(){return this}()));

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLjAsImZpbGUiOiIubWFpbi5lb2Jqcy9ieXRlL2R1bmVfX2V4ZV9fTWFpbi5jbW8uanMiLCJzb3VyY2VSb290IjoiIiwibmFtZXMiOlsiZ2JfdyIsImdiX2giLCJkcmF3X2ZyYW1lYnVmZmVyIiwiY3R4IiwiaW1hZ2VfZGF0YSIsImZiIiwiZCIsInkiLCJ4Iiwib2ZmIiwicnVuX3JvbSIsInJvbV9ieXRlcyIsImNhcnRyaWRnZSIsInQiLCJjbnQiLCJzdGFydF90aW1lIiwibWFpbl9sb29wIiwiZW5kX3RpbWUiLCJzZWNfcGVyXzYwX2ZyYW1lIiwiZnBzIiwibG9hZF9yb21fYnV0dG9uIiwiaW5wdXRfZWwiLCJidXR0b25fZWwiLCJmaWxlIiwiYnVmX2Z1dCIsImJ1ZiIsImUiLCJjbnYiXSwic291cmNlcyI6WyIvaG9tZS9ydW5uZXIvd29yay9DQU1MQk9ZL0NBTUxCT1kvX2J1aWxkL2RlZmF1bHQvYmluL3dlYi9tYWluLm1sIl0sIm1hcHBpbmdzIjoiOztJOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztLQUlJQTtLQUNBQzthQUVBQyxpQkFBaUJDLElBQUlDLFdBQVdDO01BQzFCLHNDQURlRCxZQUV2Qkc7O01BQ0U7O1FBQ0U7O3FCQUZKQSxlQUNFQztXQUVjLHVCQUFOLGlCQUx3QkgsR0FFbENFLFVBQ0VDO1VBRWM7O2FBWVYsRUFiRUM7YUFjRixFQWRFQTthQWVGLEVBZkVBO2FBZ0JGLEVBaEJFQTs7YUFHRixFQUhFQTthQUlGLEVBSkVBO2FBS0YsRUFMRUE7YUFNRixFQU5FQTs7O2FBUUYsRUFSRUE7YUFTRixFQVRFQTthQVVGLEVBVkVBO2FBV0YsRUFYRUE7O2FBa0JGLEVBbEJFQTthQW1CRixFQW5CRUE7YUFvQkYsRUFwQkVBO2FBcUJGLEVBckJFQTtVQUFKLFFBREZEOztVQUNFLFFBRkpEOztVQTBCQSxvQ0E1Qm1CSixJQUFJQyxpQkE0Qm9CO2FBRXpDTSxRQUFRQyxVQUFVUixJQUFJQztNQUNSOzREQUROTztPQUNNLG9DQUFaQztPQUVLLG9CQUhDRDtPQUdEO09BRVk7ZUFDYks7UUFDTjtVQUFZLDBCQUpWSDtVQUlVO2dCQUdJUjtZQU5kUzs7Y0FTbUI7O2VBQ2lDLGtCQUQ1Q0csV0FSUkY7ZUFVYyxVQURORztjQUNNLGdCQUZORDtjQUlLLHlCQUZMRTtjQUVLO1lBR1gsd0JBcEJjaEIsSUFBSUMsV0FVTkM7bUJBV2I7TUFFSyx3QkFqQkZXO01BaUJFLFFBQThCO2FBRXRDSSxnQkFBZ0JqQixJQUFJQztNQWlCVTs7T0FBakI7T0FDYTtPQUFaO01BQ2hCLDZDQWxCY2lCO01Ba0JkLG9CQUM2Qiw2QkFuQmZBLFNBbUJnQztNQUE5Qyx1Q0FGSUM7TUFFSjtRQWxCYTtzQ0FEQ0Q7U0FDRDtTQUVHLDZCQUZWRTtRQUVVO1VBQ0k7WUFFWjs7YUFDNEI7O2dCQUExQiwyQkFGQ0U7WUFFeUIsZUFEeEJkLFVBUE1SLElBQUlDO1VBZWQsZUFBYyw0QkFEUnNCO1VBQ1EsaUNBQXFCO1FBWDNCLHlCQUFWRixZQWlCMEM7TUFBaEQsdUNBcEJjSDtNQW9CZCxxQ0FwQmNBLFlBaUJWQyxjQUl5QjtJQUdtQjs7S0FBdEMseUNBbkZSdEIsU0FDQUM7S0FtRlEsbUNBRE4wQjtLQUVhLHdDQURieEIsSUFwRkZILEtBQ0FDO0tBcUZPLDhCQXJGUEEsS0FEQUQ7SUF1RkYsaUJBSElHLElBQ0FDLFdBQ0FDO0lBSDRDO0tBTzlDLHVCQU5FRixJQUNBQztLQUlGLG1DQU5FdUI7S0FLWTtJQUFoQjtJQUxnRCxxQkFuRjlDM0IsS0FDQUMsS0FFQUMsaUJBOEJBUSxRQXlCQVU7SUE4QkY7VSIsInNvdXJjZXNDb250ZW50IjpbIm9wZW4gQ2FtbGJveV9saWJcbm9wZW4gQnJyXG5vcGVuIEJycl9jYW52YXNcblxubGV0IGdiX3cgPSAxNjBcbmxldCBnYl9oID0gMTQ0XG5cbmxldCBkcmF3X2ZyYW1lYnVmZmVyIGN0eCBpbWFnZV9kYXRhIGZiID1cbiAgbGV0IGQgPSBDMmQuSW1hZ2VfZGF0YS5kYXRhIGltYWdlX2RhdGEgaW5cbiAgZm9yIHkgPSAwIHRvIGdiX2ggLSAxIGRvXG4gICAgZm9yIHggPSAwIHRvIGdiX3cgLSAxIGRvXG4gICAgICBsZXQgb2ZmID0gNCAqICh5ICogZ2JfdyArIHgpIGluXG4gICAgICBtYXRjaCBmYi4oeSkuKHgpIHdpdGhcbiAgICAgIHwgYFdoaXRlIC0+XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICAgICkgMHhGRjtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAxKSAweEZGO1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDIpIDB4RkY7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMykgMHhGRjtcbiAgICAgIHwgYExpZ2h0X2dyYXkgLT5cbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgICAgKSAweEFBO1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDEpIDB4QUE7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMikgMHhBQTtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAzKSAweEZGO1xuICAgICAgfCBgRGFya19ncmF5IC0+XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICAgICkgMHg3NztcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAxKSAweDc3O1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDIpIDB4Nzc7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMykgMHhGRjtcbiAgICAgIHwgYEJsYWNrIC0+XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICAgICkgMHgwMDtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAxKSAweDAwO1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDIpIDB4MDA7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMykgMHhGRjtcbiAgICBkb25lXG4gIGRvbmU7XG4gIEMyZC5wdXRfaW1hZ2VfZGF0YSBjdHggaW1hZ2VfZGF0YSB+eDowIH55OjBcblxubGV0IHJ1bl9yb20gcm9tX2J5dGVzIGN0eCBpbWFnZV9kYXRhID1cbiAgbGV0IGNhcnRyaWRnZSA9IERldGVjdF9jYXJ0cmlkZ2UuZiB+cm9tX2J5dGVzIGluXG4gIGxldCBtb2R1bGUgQyA9IENhbWxib3kuTWFrZSh2YWwgY2FydHJpZGdlKSBpblxuICBsZXQgdCA9ICBDLmNyZWF0ZV93aXRoX3JvbSB+cHJpbnRfc2VyaWFsX3BvcnQ6dHJ1ZSB+cm9tX2J5dGVzIGluXG4gIGxldCBjbnQgPSByZWYgMCBpblxuICBsZXQgc3RhcnRfdGltZSA9IHJlZiAoUGVyZm9ybWFuY2Uubm93X21zIEcucGVyZm9ybWFuY2UpIGluXG4gIGxldCByZWMgbWFpbl9sb29wICgpID1cbiAgICBiZWdpbiBtYXRjaCBDLnJ1bl9pbnN0cnVjdGlvbiB0IHdpdGhcbiAgICAgIHwgSW5fZnJhbWUgLT5cbiAgICAgICAgbWFpbl9sb29wICgpXG4gICAgICB8IEZyYW1lX2VuZGVkIGZiIC0+XG4gICAgICAgIGluY3IgY250O1xuICAgICAgICBpZiAhY250ID0gNjAgdGhlbiBiZWdpblxuICAgICAgICAgIGxldCBlbmRfdGltZSA9IFBlcmZvcm1hbmNlLm5vd19tcyBHLnBlcmZvcm1hbmNlIGluXG4gICAgICAgICAgbGV0IHNlY19wZXJfNjBfZnJhbWUgPSAoZW5kX3RpbWUgLS4gIXN0YXJ0X3RpbWUpIC8uIDEwMDAuIGluXG4gICAgICAgICAgbGV0IGZwcyA9IDYwLiAvLiAgc2VjX3Blcl82MF9mcmFtZSBpblxuICAgICAgICAgIHN0YXJ0X3RpbWUgOj0gZW5kX3RpbWU7XG4gICAgICAgICAgQ29uc29sZS4obG9nIFtmcHNdKTtcbiAgICAgICAgICBjbnQgOj0gMDtcbiAgICAgICAgZW5kO1xuICAgICAgICBkcmF3X2ZyYW1lYnVmZmVyIGN0eCBpbWFnZV9kYXRhIGZiO1xuICAgIGVuZDtcbiAgaW5cbiAgaWdub3JlIEBAIEcuc2V0X2ludGVydmFsIH5tczoxIG1haW5fbG9vcFxuXG5sZXQgbG9hZF9yb21fYnV0dG9uIGN0eCBpbWFnZV9kYXRhID1cbiAgbGV0IG9uX2NoYW5nZSBpbnB1dF9lbCA9XG4gICAgbGV0IGZpbGUgPSBFbC5JbnB1dC5maWxlcyBpbnB1dF9lbCB8PiBMaXN0LmhkIGluXG4gICAgbGV0IGJsb2IgPSBGaWxlLmFzX2Jsb2IgZmlsZSBpblxuICAgIGxldCBidWZfZnV0ID0gQmxvYi5hcnJheV9idWZmZXIgYmxvYiBpblxuICAgIEZ1dC5hd2FpdCBidWZfZnV0IChmdW5jdGlvblxuICAgICAgICB8IE9rIGJ1ZiAtPlxuICAgICAgICAgIGxldCByb21fYnl0ZXMgPVxuICAgICAgICAgICAgVGFycmF5Lm9mX2J1ZmZlciBVaW50OCBidWZcbiAgICAgICAgICAgIHw+IFRhcnJheS50b19iaWdhcnJheTFcbiAgICAgICAgICAgICgqIENvbnZlcnQgdWludDggYmlnYXJyYXkgdG8gY2hhciBiaWdhcnJheSAqKVxuICAgICAgICAgICAgfD4gT2JqLm1hZ2ljXG4gICAgICAgICAgaW5cbiAgICAgICAgICBydW5fcm9tIHJvbV9ieXRlcyBjdHggaW1hZ2VfZGF0YVxuICAgICAgICB8IEVycm9yIGUgLT5cbiAgICAgICAgICBDb25zb2xlLihsb2cgW0p2LkVycm9yLm1lc3NhZ2UgZV0pKVxuICBpblxuICBsZXQgaW5wdXRfZWwgPSBFbC5pbnB1dCB+YXQ6QXQuW3R5cGUnIChKc3RyLnYgXCJmaWxlXCIpXSAoKSBpblxuICBsZXQgYnV0dG9uX2VsID0gRWwuYnV0dG9uIFsgRWwudHh0JyBcIkxvYWQgUm9tXCIgXSBpblxuICBFbC5zZXRfaW5saW5lX3N0eWxlIEVsLlN0eWxlLmRpc3BsYXkgKEpzdHIudiBcIm5vbmVcIikgaW5wdXRfZWw7XG4gIEV2Lmxpc3RlbiBFdi5jbGljayAoZnVuIF8gLT4gRWwuY2xpY2sgaW5wdXRfZWwpIChFbC5hc190YXJnZXQgYnV0dG9uX2VsKTtcbiAgRXYubGlzdGVuIEV2LmNoYW5nZSAoZnVuIF8gLT4gb25fY2hhbmdlIGlucHV0X2VsKSAoRWwuYXNfdGFyZ2V0IGlucHV0X2VsKTtcbiAgRWwuc3BhbiBbaW5wdXRfZWw7IGJ1dHRvbl9lbF1cblxubGV0ICgpID1cbiAgbGV0IGNudiA9IENhbnZhcy5jcmVhdGUgfnc6Z2JfdyB+aDpnYl9oIH5hdDpBdC5baWQgKEpzdHIudiBcInNjcmVlblwiKV0gW10gaW5cbiAgbGV0IGN0eCA9IEMyZC5jcmVhdGUgY252IGluXG4gIGxldCBpbWFnZV9kYXRhID0gQzJkLmNyZWF0ZV9pbWFnZV9kYXRhIGN0eCB+dzpnYl93IH5oOmdiX2ggaW5cbiAgbGV0IGZiID0gQXJyYXkubWFrZV9tYXRyaXggZ2JfaCBnYl93IGBEYXJrX2dyYXkgaW5cbiAgZHJhd19mcmFtZWJ1ZmZlciBjdHggaW1hZ2VfZGF0YSBmYjtcbiAgRWwuc2V0X2NoaWxkcmVuIChEb2N1bWVudC5ib2R5IEcuZG9jdW1lbnQpIFtcbiAgICBDYW52YXMudG9fZWwgY252O1xuICAgIGxvYWRfcm9tX2J1dHRvbiBjdHggaW1hZ2VfZGF0YTtcbiAgXVxuIl19
