(function(joo_global_object)
   {"use strict";
    var
     runtime=joo_global_object.jsoo_runtime,
     caml_jsstring_of_string=runtime.caml_jsstring_of_string,
     caml_string_of_jsbytes=runtime.caml_string_of_jsbytes;
    function caml_call1(f,a0)
     {return f.length == 1?f(a0):runtime.caml_call_gen(f,[a0])}
    function caml_call2(f,a0,a1)
     {return f.length == 2?f(a0,a1):runtime.caml_call_gen(f,[a0,a1])}
    function caml_call4(f,a0,a1,a2,a3)
     {return f.length == 4
              ?f(a0,a1,a2,a3)
              :runtime.caml_call_gen(f,[a0,a1,a2,a3])}
    function caml_call9(f,a0,a1,a2,a3,a4,a5,a6,a7,a8)
     {return f.length == 9
              ?f(a0,a1,a2,a3,a4,a5,a6,a7,a8)
              :runtime.caml_call_gen(f,[a0,a1,a2,a3,a4,a5,a6,a7,a8])}
    var
     global_data=runtime.caml_get_global_data(),
     cst_FPS=caml_string_of_jsbytes("FPS"),
     cst_Duration=caml_string_of_jsbytes("Duration"),
     cst_Frames=caml_string_of_jsbytes("Frames"),
     cst_ROM_path=caml_string_of_jsbytes("ROM path"),
     partial=
      [8,
       [0,0,0],
       0,
       0,
       [12,
        10,
        [2,
         [0,1,8],
         [11,caml_string_of_jsbytes(": "),[8,[0,0,0],0,0,[12,10,0]]]]]],
     cst_bench_result=caml_string_of_jsbytes("bench_result"),
     cst_rom_path=caml_string_of_jsbytes("rom_path"),
     cst_frames=caml_string_of_jsbytes("frames"),
     Stdlib_Printf=global_data.Stdlib__Printf,
     Brr=global_data.Brr,
     Stdlib=global_data.Stdlib,
     Jv=global_data.Jv,
     Fut=global_data.Fut,
     Brr_io=global_data.Brr_io,
     Camlboy_lib_Detect_cartridge=global_data.Camlboy_lib__Detect_cartridge,
     Camlboy_lib_Camlboy=global_data.Camlboy_lib__Camlboy,
     Stdlib_Option=global_data.Stdlib__Option,
     _c_=
      [0,
       [2,
        [0,1,8],
        [11,
         caml_string_of_jsbytes(": "),
         [2,
          0,
          [12,
           10,
           [2,
            [0,1,8],
            [11,
             caml_string_of_jsbytes(": "),
             [4,
              0,
              0,
              0,
              [12,10,[2,[0,1,8],[11,caml_string_of_jsbytes(": "),partial]]]]]]]]]],
       caml_string_of_jsbytes("%8s: %s\n%8s: %d\n%8s: %f\n%8s: %f\n")],
     _a_=
      [0,
       [11,
        caml_string_of_jsbytes("Parameter "),
        [2,0,[11,caml_string_of_jsbytes(" missing in URL"),0]]],
       caml_string_of_jsbytes("Parameter %s missing in URL")];
    function alert(v)
     {var alert=Jv[12].alert;alert(caml_call1(Jv[23],v));return 0}
    function find_el_by_id(id)
     {var _r_=caml_call2(Brr[10][2],Brr[16][2],caml_jsstring_of_string(id));
      return caml_call1(Stdlib_Option[4],_r_)}
    function run_rom_bytes(rom_bytes,frames)
     {var
       cartridge=caml_call1(Camlboy_lib_Detect_cartridge[1],rom_bytes),
       C=caml_call1(Camlboy_lib_Camlboy[1],cartridge),
       t=caml_call2(C[2],0,rom_bytes),
       frame_count=[0,0],
       _q_=caml_call1(Brr[15][9],Brr[16][4]);
      for(;;)
       {if(frame_count[1] < frames)
         {var match=caml_call1(C[3],t);if(match)frame_count[1]++;continue}
        return caml_call1(Brr[15][9],Brr[16][4]) - _q_}}
    function run_rom_blob(rom_blob,frames)
     {function _m_(result)
       {if(0 === result[0])
         {var
           buf=result[1],
           rom_bytes=
            runtime.caml_ba_from_typed_array(caml_call4(Brr[1][5],3,0,0,buf)),
           _o_=run_rom_bytes(rom_bytes,frames);
          return caml_call1(Fut[3],_o_)}
        var e=result[1],_p_=[0,caml_call1(Jv[30][4],e),0];
        caml_call1(Brr[12][9],_p_);
        return caml_call1(Fut[3],0.)}
      var _n_=caml_call1(Brr[2][8],rom_blob);
      return caml_call2(Fut[15][1],_n_,_m_)}
    function run_rom_path(rom_path,frames)
     {function _g_(result)
       {if(0 === result[0])
         {var
           response=result[1],
           _i_=
            function(result)
             {if(0 === result[0])
               {var blob=result[1];return run_rom_blob(blob,frames)}
              var e=result[1],_l_=[0,caml_call1(Jv[30][4],e),0];
              caml_call1(Brr[12][9],_l_);
              return caml_call1(Fut[3],0.)},
           _j_=caml_call1(Brr_io[3][1][9],response);
          return caml_call2(Fut[15][1],_j_,_i_)}
        var e=result[1],_k_=[0,caml_call1(Jv[30][4],e),0];
        caml_call1(Brr[12][9],_k_);
        return caml_call1(Fut[3],0.)}
      var _h_=caml_call2(Brr_io[3][7],0,caml_jsstring_of_string(rom_path));
      return caml_call2(Fut[15][1],_h_,_g_)}
    function read_param(param_key)
     {var
       uri=caml_call1(Brr[13][12],Brr[16][5]),
       _e_=caml_call1(Brr[6][6],uri),
       _f_=caml_call1(Brr[6][9][7],_e_),
       param=
        caml_call1
         (caml_call1(Brr[6][9][3],caml_jsstring_of_string(param_key)),_f_);
      if(param)
       {var jstr=param[1];return runtime.caml_string_of_jsstring(jstr)}
      var msg=caml_call2(Stdlib_Printf[4],_a_,param_key);
      alert(msg);
      return caml_call1(Stdlib[2],msg)}
    var
     rom_path=read_param(cst_rom_path),
     frames=runtime.caml_int_of_string(read_param(cst_frames)),
     fut=run_rom_path(rom_path,frames);
    function _b_(duration_ms)
     {var
       duration=duration_ms / 1000.,
       fps=frames / duration,
       msg=
        caml_call9
         (Stdlib_Printf[4],
          _c_,
          cst_ROM_path,
          rom_path,
          cst_Frames,
          frames,
          cst_Duration,
          duration,
          cst_FPS,
          fps),
       result_el=find_el_by_id(cst_bench_result),
       _d_=[0,caml_call2(Brr[9][2],0,caml_jsstring_of_string(msg)),0];
      return caml_call2(Brr[9][18],result_el,_d_)}
    caml_call2(Fut[2],fut,_b_);
    var
     Dune_exe_Bench=
      [0,
       alert,
       find_el_by_id,
       run_rom_bytes,
       run_rom_blob,
       run_rom_path,
       read_param];
    runtime.caml_register_global(23,Dune_exe_Bench,"Dune__exe__Bench");
    return}
  (function(){return this}()));

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLjAsImZpbGUiOiIuaW5kZXguZW9ianMvYnl0ZS9kdW5lX19leGVfX0JlbmNoLmNtby5qcyIsInNvdXJjZVJvb3QiOiIiLCJuYW1lcyI6WyJhbGVydCIsInYiLCJmaW5kX2VsX2J5X2lkIiwiaWQiLCJydW5fcm9tX2J5dGVzIiwicm9tX2J5dGVzIiwiZnJhbWVzIiwiY2FydHJpZGdlIiwidCIsImZyYW1lX2NvdW50IiwicnVuX3JvbV9ibG9iIiwicm9tX2Jsb2IiLCJyZXN1bHQiLCJidWYiLCJlIiwicnVuX3JvbV9wYXRoIiwicm9tX3BhdGgiLCJyZXNwb25zZSIsImJsb2IiLCJyZWFkX3BhcmFtIiwicGFyYW1fa2V5IiwidXJpIiwicGFyYW0iLCJqc3RyIiwibXNnIiwiZnV0IiwiZHVyYXRpb25fbXMiLCJkdXJhdGlvbiIsImZwcyIsInJlc3VsdF9lbCJdLCJzb3VyY2VzIjpbIi9ob21lL3J1bm5lci93b3JrL0NBTUxCT1kvQ0FNTEJPWS9fYnVpbGQvZGVmYXVsdC9iaW4vd2ViL2JlbmNoLm1sIl0sIm1hcHBpbmdzIjoiOztJOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7O2FBS0lBLE1BQU1DO01BQ0ksSUFBUkQsbUJBQ00sTUFBcUIsa0JBRnZCQyxJQUVFLFFBQW1DO2FBRTNDQyxjQUFjQztNQUFLLHlDQUFrQyx3QkFBdkNBO01BQUssdUNBQTJEO2FBRTlFQyxjQUFjQyxVQUFVQztNQUNWOzREQURBRDtPQUNBLG9DQUFaRTtPQUVLLG9CQUhPRjtPQUdQO09BRVk7O1dBRGpCSSxpQkFKc0JIO1VBT2xCLDBCQUpKRSxHQUlJLFNBRWE7UUFFYSxPQUFsQyx3Q0FBaUQ7YUFFL0NFLGFBQWFDLFNBQVNMO01BQ3hCLGFBQUtNO1FBQ0wsU0FES0E7VUFHSDtlQUhHQTtXQUl5Qjs2Q0FBMUIsMkJBRkNDO1dBT1csa0JBTlZSLFVBSmtCQztVQVVSO1FBRWQsTUFYR00sVUFXVyw0QkFEUkU7UUFDRztvQ0FDSTtNQVpELDZCQURDSDtNQUNELHFDQVlDO2FBRWJJLGFBQWFDLFNBQVNWO01BQ3hCLGFBQUtNO1FBQ0wsU0FES0E7VUFHSDtvQkFIR0E7V0FHSDtxQkFDS0E7Y0FDTCxTQURLQTtnQkFFVSxJQUFSTSxLQUZGTixVQUVVLG9CQUFSTSxLQVBlWjtjQVFOLE1BSFhNLFVBR3lCLDRCQUFwQkU7Y0FBZTswQ0FDdEI7V0FKVywrQkFGWEc7VUFFVztRQUtGLE1BVFRMLFVBU3VCLDRCQUFwQkU7UUFBZTtvQ0FBd0M7TUFUakQsa0NBQVUsd0JBRFRFO01BQ0QscUNBU2lEO2FBRTdERyxXQUFXQztNQUNIOztPQUVSLHlCQUZFQztPQUVGO09BR3FDOztVQUFsQyx3QkFBc0Isd0JBTmREO01BTTBCLEdBSm5DRTtRQU9XLElBQVJDLEtBUEhELFNBT1csdUNBQVJDO01BUkcsSUFVSkMsSUFBTSxnQ0FYQ0o7TUFZWCxNQURJSTtNQUNKLDRCQURJQSxJQUVRO0lBS0M7O0tBQ2lCLGtDQUFuQjtLQUVILGlCQUhOUixTQUNBVjtJQUVNLGFBQ1NvQjtNQUNBO2dCQURBQTtPQUVlLElBTDlCcEIsU0FJSXFCO09BRU07Ozs7O1VBUFZYOztVQUNBVjs7VUFJSXFCOztVQUNBQztPQU9ZO09BQ1csOEJBQU8sd0JBUDlCSjtNQU91Qiw2QkFEdkJLLGNBQzJDO0lBVm5ELGtCQURJSjtJQUNKOzs7T0FwRUV6QjtPQUlBRTtPQUVBRTtPQWFBTTtPQWVBSztPQVlBSTtJQXNCRjtVIiwic291cmNlc0NvbnRlbnQiOlsib3BlbiBDYW1sYm95X2xpYlxub3BlbiBCcnJcbm9wZW4gQnJyX2lvXG5vcGVuIEZ1dC5TeW50YXhcblxubGV0IGFsZXJ0IHYgPVxuICBsZXQgYWxlcnQgPSBKdi5nZXQgSnYuZ2xvYmFsIFwiYWxlcnRcIiBpblxuICBpZ25vcmUgQEAgSnYuYXBwbHkgYWxlcnQgSnYuW3wgb2Zfc3RyaW5nIHYgfF1cblxubGV0IGZpbmRfZWxfYnlfaWQgaWQgPSBEb2N1bWVudC5maW5kX2VsX2J5X2lkIEcuZG9jdW1lbnQgKEpzdHIudiBpZCkgfD4gT3B0aW9uLmdldFxuXG5sZXQgcnVuX3JvbV9ieXRlcyByb21fYnl0ZXMgZnJhbWVzID1cbiAgbGV0IGNhcnRyaWRnZSA9IERldGVjdF9jYXJ0cmlkZ2UuZiB+cm9tX2J5dGVzIGluXG4gIGxldCBtb2R1bGUgQyA9IENhbWxib3kuTWFrZSh2YWwgY2FydHJpZGdlKSBpblxuICBsZXQgdCA9ICBDLmNyZWF0ZV93aXRoX3JvbSB+cHJpbnRfc2VyaWFsX3BvcnQ6ZmFsc2UgfnJvbV9ieXRlcyBpblxuICBsZXQgZnJhbWVfY291bnQgPSByZWYgMCBpblxuICBsZXQgc3RhcnRfdGltZSA9IHJlZiAoUGVyZm9ybWFuY2Uubm93X21zIEcucGVyZm9ybWFuY2UpIGluXG4gIHdoaWxlICFmcmFtZV9jb3VudCA8IGZyYW1lcyBkb1xuICAgIG1hdGNoIEMucnVuX2luc3RydWN0aW9uIHQgd2l0aFxuICAgIHwgSW5fZnJhbWUgLT4gKClcbiAgICB8IEZyYW1lX2VuZGVkIF8gLT4gaW5jciBmcmFtZV9jb3VudFxuICBkb25lO1xuICAoUGVyZm9ybWFuY2Uubm93X21zIEcucGVyZm9ybWFuY2UpIC0uICFzdGFydF90aW1lXG5cbmxldCBydW5fcm9tX2Jsb2Igcm9tX2Jsb2IgZnJhbWVzID1cbiAgbGV0KiByZXN1bHQgPSBCbG9iLmFycmF5X2J1ZmZlciByb21fYmxvYiBpblxuICBtYXRjaCByZXN1bHQgd2l0aFxuICB8IE9rIGJ1ZiAtPlxuICAgIGxldCByb21fYnl0ZXMgPVxuICAgICAgVGFycmF5Lm9mX2J1ZmZlciBVaW50OCBidWZcbiAgICAgIHw+IFRhcnJheS50b19iaWdhcnJheTFcbiAgICAgICgqIENvbnZlcnQgdWludDggYmlnYXJyYXkgdG8gY2hhciBiaWdhcnJheSAqKVxuICAgICAgfD4gT2JqLm1hZ2ljXG4gICAgaW5cbiAgICBGdXQucmV0dXJuIEBAIHJ1bl9yb21fYnl0ZXMgcm9tX2J5dGVzIGZyYW1lc1xuICB8IEVycm9yIGUgLT5cbiAgICBDb25zb2xlLihsb2cgW0p2LkVycm9yLm1lc3NhZ2UgZV0pO1xuICAgIEZ1dC5yZXR1cm4gMC5cblxubGV0IHJ1bl9yb21fcGF0aCByb21fcGF0aCBmcmFtZXMgPVxuICBsZXQqIHJlc3VsdCA9IEZldGNoLnVybCAoSnN0ci52IHJvbV9wYXRoKSBpblxuICBtYXRjaCByZXN1bHQgd2l0aFxuICB8IE9rIHJlc3BvbnNlIC0+XG4gICAgbGV0IGJvZHkgPSBGZXRjaC5SZXNwb25zZS5hc19ib2R5IHJlc3BvbnNlIGluXG4gICAgbGV0KiByZXN1bHQgPSBGZXRjaC5Cb2R5LmJsb2IgYm9keSBpblxuICAgIGJlZ2luIG1hdGNoIHJlc3VsdCB3aXRoXG4gICAgICB8IE9rIGJsb2IgLT4gcnVuX3JvbV9ibG9iIGJsb2IgZnJhbWVzXG4gICAgICB8IEVycm9yIGUgIC0+IENvbnNvbGUuKGxvZyBbSnYuRXJyb3IubWVzc2FnZSBlXSk7IEZ1dC5yZXR1cm4gMC5cbiAgICBlbmRcbiAgfCBFcnJvciBlICAtPiBDb25zb2xlLihsb2cgW0p2LkVycm9yLm1lc3NhZ2UgZV0pOyBGdXQucmV0dXJuIDAuXG5cbmxldCByZWFkX3BhcmFtIHBhcmFtX2tleSA9XG4gIGxldCB1cmkgPSBXaW5kb3cubG9jYXRpb24gRy53aW5kb3cgaW5cbiAgbGV0IHBhcmFtID1cbiAgICB1cmlcbiAgICB8PiBVcmkucXVlcnlcbiAgICB8PiBVcmkuUGFyYW1zLm9mX2pzdHJcbiAgICB8PiBVcmkuUGFyYW1zLmZpbmQgSnN0ci4odiBwYXJhbV9rZXkpXG4gIGluXG4gIG1hdGNoIHBhcmFtIHdpdGhcbiAgfCBTb21lIGpzdHIgLT4gSnN0ci50b19zdHJpbmcganN0clxuICB8IE5vbmUgLT5cbiAgICBsZXQgbXNnID0gUHJpbnRmLnNwcmludGYgXCJQYXJhbWV0ZXIgJXMgbWlzc2luZyBpbiBVUkxcIiBwYXJhbV9rZXkgaW5cbiAgICBhbGVydCBtc2c7XG4gICAgZmFpbHdpdGggbXNnXG5cblxubGV0ICgpID1cbiAgKCogUmVhZCBVUkwgcGFyYW1ldGVycyAqKVxuICBsZXQgcm9tX3BhdGggPSByZWFkX3BhcmFtIFwicm9tX3BhdGhcIiBpblxuICBsZXQgZnJhbWVzID0gcmVhZF9wYXJhbSBcImZyYW1lc1wiIHw+IGludF9vZl9zdHJpbmcgaW5cbiAgKCogTG9hZCBpbml0aWFsIHJvbSAqKVxuICBsZXQgZnV0ID0gcnVuX3JvbV9wYXRoIHJvbV9wYXRoIGZyYW1lcyBpblxuICBGdXQuYXdhaXQgZnV0IChmdW4gZHVyYXRpb25fbXMgLT5cbiAgICAgIGxldCBkdXJhdGlvbiA9IGR1cmF0aW9uX21zIC8uIDEwMDAuIGluXG4gICAgICBsZXQgZnBzID0gRmxvYXQuKG9mX2ludCBmcmFtZXMgLy4gZHVyYXRpb24pIGluXG4gICAgICBsZXQgbXNnID0gUHJpbnRmLnNwcmludGYgXCIlOHM6ICVzXFxuJThzOiAlZFxcbiU4czogJWZcXG4lOHM6ICVmXFxuXCJcbiAgICAgICAgICBcIlJPTSBwYXRoXCIgcm9tX3BhdGhcbiAgICAgICAgICBcIkZyYW1lc1wiIGZyYW1lc1xuICAgICAgICAgIFwiRHVyYXRpb25cIiBkdXJhdGlvblxuICAgICAgICAgIFwiRlBTXCIgZnBzXG4gICAgICBpblxuICAgICAgbGV0IHJlc3VsdF9lbCA9IGZpbmRfZWxfYnlfaWQgXCJiZW5jaF9yZXN1bHRcIiBpblxuICAgICAgRWwuc2V0X2NoaWxkcmVuIHJlc3VsdF9lbCBbRWwudHh0IChKc3RyLnYgbXNnKV0pXG4iXX0=
