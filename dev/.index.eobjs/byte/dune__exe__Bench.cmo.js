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
     cst_tobu_gb=caml_string_of_jsbytes("tobu.gb"),
     cst_rom_path=caml_string_of_jsbytes("rom_path"),
     cst_1500=caml_string_of_jsbytes("1500"),
     cst_frames=caml_string_of_jsbytes("frames"),
     Stdlib_Printf=global_data.Stdlib__Printf,
     Brr=global_data.Brr,
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
       caml_string_of_jsbytes("%8s: %s\n%8s: %d\n%8s: %f\n%8s: %f\n")];
    function alert(v)
     {var _ag_=Jv[12],alert=_ag_.alert,_ah_=Jv[23],_ai_=caml_call1(_ah_,v);
      alert(_ai_);
      return 0}
    function find_el_by_id(id)
     {var
       _ac_=caml_jsstring_of_string(id),
       _ad_=Brr[16][2],
       _ae_=Brr[10][2],
       _af_=caml_call2(_ae_,_ad_,_ac_);
      return caml_call1(Stdlib_Option[4],_af_)}
    function run_rom_bytes(rom_bytes,frames)
     {var
       _U_=Camlboy_lib_Detect_cartridge[1],
       cartridge=caml_call1(_U_,rom_bytes),
       C=caml_call1(Camlboy_lib_Camlboy[1],cartridge),
       _V_=0,
       _W_=C[2],
       t=caml_call2(_W_,_V_,rom_bytes),
       frame_count=[0,0],
       _X_=Brr[16][4],
       _Y_=Brr[15][9],
       _Z_=caml_call1(_Y_,_X_);
      for(;;)
       {if(frame_count[1] < frames)
         {var ___=C[3],match=caml_call1(___,t);
          if(match)frame_count[1]++;
          continue}
        var _$_=Brr[16][4],_aa_=Brr[15][9],_ab_=caml_call1(_aa_,_$_);
        return _ab_ - _Z_}}
    function run_rom_blob(rom_blob,frames)
     {function _H_(result)
       {if(0 === result[0])
         {var
           buf=result[1],
           _K_=0,
           _L_=0,
           _M_=3,
           _N_=Brr[1][5],
           _O_=caml_call4(_N_,_M_,_L_,_K_,buf),
           rom_bytes=runtime.caml_ba_from_typed_array(_O_),
           _P_=run_rom_bytes(rom_bytes,frames);
          return caml_call1(Fut[3],_P_)}
        var
         e=result[1],
         _Q_=0,
         _R_=Jv[30][4],
         _S_=[0,caml_call1(_R_,e),_Q_],
         _T_=Brr[12][9];
        caml_call1(_T_,_S_);
        return caml_call1(Fut[3],0.)}
      var _I_=Brr[2][8],_J_=caml_call1(_I_,rom_blob);
      return caml_call2(Fut[15][1],_J_,_H_)}
    function run_rom_path(rom_path,frames)
     {function _r_(result)
       {if(0 === result[0])
         {var
           response=result[1],
           _w_=
            function(result)
             {if(0 === result[0])
               {var blob=result[1];return run_rom_blob(blob,frames)}
              var
               e=result[1],
               _D_=0,
               _E_=Jv[30][4],
               _F_=[0,caml_call1(_E_,e),_D_],
               _G_=Brr[12][9];
              caml_call1(_G_,_F_);
              return caml_call1(Fut[3],0.)},
           _x_=Brr_io[3][1][9],
           _y_=caml_call1(_x_,response);
          return caml_call2(Fut[15][1],_y_,_w_)}
        var
         e=result[1],
         _z_=0,
         _A_=Jv[30][4],
         _B_=[0,caml_call1(_A_,e),_z_],
         _C_=Brr[12][9];
        caml_call1(_C_,_B_);
        return caml_call1(Fut[3],0.)}
      var
       _s_=caml_jsstring_of_string(rom_path),
       _t_=0,
       _u_=Brr_io[3][7],
       _v_=caml_call2(_u_,_t_,_s_);
      return caml_call2(Fut[15][1],_v_,_r_)}
    function read_param(param_key,default$0)
     {var
       _k_=Brr[16][5],
       _l_=Brr[13][12],
       uri=caml_call1(_l_,_k_),
       _m_=Brr[6][6],
       _n_=caml_call1(_m_,uri),
       _o_=Brr[6][9][7],
       param=caml_call1(_o_,_n_),
       _p_=caml_jsstring_of_string(param_key),
       _q_=Brr[6][9][3],
       match=caml_call2(_q_,_p_,param);
      if(match)
       {var jstr=match[1];return runtime.caml_string_of_jsstring(jstr)}
      return default$0}
    var
     rom_path=read_param(cst_rom_path,cst_tobu_gb),
     _a_=read_param(cst_frames,cst_1500),
     frames=runtime.caml_int_of_string(_a_),
     fut=run_rom_path(rom_path,frames);
    function _b_(duration_ms)
     {var
       duration=duration_ms / 1000.,
       fps=frames / duration,
       _e_=Stdlib_Printf[4],
       msg=
        caml_call9
         (_e_,
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
       _f_=0,
       _g_=caml_jsstring_of_string(msg),
       _h_=0,
       _i_=Brr[9][2],
       _j_=[0,caml_call2(_i_,_h_,_g_),_f_];
      return caml_call2(Brr[9][18],result_el,_j_)}
    var _d_=Fut[2];
    caml_call2(_d_,fut,_b_);
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

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLjAsImZpbGUiOiIuaW5kZXguZW9ianMvYnl0ZS9kdW5lX19leGVfX0JlbmNoLmNtby5qcyIsInNvdXJjZVJvb3QiOiIiLCJuYW1lcyI6WyJhbGVydCIsInYiLCJmaW5kX2VsX2J5X2lkIiwiaWQiLCJydW5fcm9tX2J5dGVzIiwicm9tX2J5dGVzIiwiZnJhbWVzIiwiY2FydHJpZGdlIiwidCIsImZyYW1lX2NvdW50IiwicnVuX3JvbV9ibG9iIiwicm9tX2Jsb2IiLCJyZXN1bHQiLCJidWYiLCJlIiwicnVuX3JvbV9wYXRoIiwicm9tX3BhdGgiLCJyZXNwb25zZSIsImJsb2IiLCJyZWFkX3BhcmFtIiwicGFyYW1fa2V5IiwiZGVmYXVsdCQwIiwidXJpIiwicGFyYW0iLCJqc3RyIiwiZnV0IiwiZHVyYXRpb25fbXMiLCJkdXJhdGlvbiIsImZwcyIsIm1zZyIsInJlc3VsdF9lbCJdLCJzb3VyY2VzIjpbIi9ob21lL3J1bm5lci93b3JrL0NBTUxCT1kvQ0FNTEJPWS9fYnVpbGQtZGV2L2RlZmF1bHQvYmluL3dlYi9iZW5jaC5tbCJdLCJtYXBwaW5ncyI6Ijs7STs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7YUFLSUEsTUFBTUM7TUFDUixnQkFBWSw2QkFDbUIscUJBRnZCQTtNQUVFO2NBQW1DO2FBRTNDQyxjQUFjQztNQUF1QztvQ0FBdkNBO09BQXVDOztPQUFsQzs4Q0FBMkQ7YUFFOUVDLGNBQWNDLFVBQVVDO01BQzFCOztPQUFnQix5QkFEQUQ7T0FDQSxvQ0FBWkU7T0FBWTs7T0FFUCxxQkFIT0Y7T0FHUDs7O09BRVk7O1dBRGpCSSxpQkFKc0JIO1VBT3hCLGFBQU0scUJBSkpFO1VBSUksU0FFYTs7UUFFckI7UUFBa0Msa0JBQWU7YUFFL0NFLGFBQWFDLFNBQVNMO01BQ3hCLGFBQUtNO1FBQ0wsU0FES0E7VUFHSDtlQUhHQTtXQUdIOzs7O1dBQ0UsK0JBRkNDO1dBRXlCO1dBS2Qsa0JBTlZSLFVBSmtCQztVQVVSO1FBRWQ7V0FYR007U0FXSDs7U0FBYyxzQkFEUkU7U0FDUTtRQUFMO29DQUNJO01BWmYsa0JBQWMsbUJBRENIO01BQ0QscUNBWUM7YUFFYkksYUFBYUMsU0FBU1Y7TUFDeEIsYUFBS007UUFDTCxTQURLQTtVQUdIO29CQUhHQTtXQUdIO3FCQUNLQTtjQUNMLFNBREtBO2dCQUVVLElBQVJNLEtBRkZOLFVBRVUsb0JBQVJNLEtBUGVaO2NBUU47aUJBSFhNO2VBR1c7O2VBQWMsc0JBQXBCRTtlQUFvQjtjQUFMOzBDQUN0QjtXQUxIO1dBQ2MsbUJBRlhHO1VBRVc7UUFLRjtXQVRUTDtTQVNTOztTQUFjLHNCQUFwQkU7U0FBb0I7UUFBTDtvQ0FBd0M7TUFUdkM7bUNBRFRFO09BQ1M7O09BQVY7MkNBU2lEO2FBRTdERyxXQUFXQyxVQUFXQztNQUN4Qjs7O09BQVU7O09BRVIsbUJBRkVDO09BRUY7O09BSTBCLDRCQVBmRjtPQU9lO09BQXRCLHlCQUxGRztNQUtFO1FBQ1MsSUFBUkMsY0FBUSx1Q0FBUkE7TUFDRyxPQVRjSCxTQVNQO0lBSUY7O0tBQ0Y7S0FBbUM7S0FFdEMsaUJBSE5MLFNBQ0FWO0lBRU0sYUFDU29CO01BQ0E7Z0JBREFBO09BRWUsSUFMOUJwQixTQUlJcUI7T0FDMEI7T0FDcEI7Ozs7O1VBUFZYOztVQUNBVjs7VUFJSXFCOztVQUNBQztPQU9ZOztPQUNrQiw0QkFQOUJDO09BTzhCOztPQUFQO21DQUR2QkMsY0FDMkM7SUFYekM7SUFDVixlQURJTDtJQUFNOzs7T0E5RFJ6QjtPQUlBRTtPQUVBRTtPQWFBTTtPQWVBSztPQVlBSTtJQWlCRjtVIiwic291cmNlc0NvbnRlbnQiOlsib3BlbiBDYW1sYm95X2xpYlxub3BlbiBCcnJcbm9wZW4gQnJyX2lvXG5vcGVuIEZ1dC5TeW50YXhcblxubGV0IGFsZXJ0IHYgPVxuICBsZXQgYWxlcnQgPSBKdi5nZXQgSnYuZ2xvYmFsIFwiYWxlcnRcIiBpblxuICBpZ25vcmUgQEAgSnYuYXBwbHkgYWxlcnQgSnYuW3wgb2Zfc3RyaW5nIHYgfF1cblxubGV0IGZpbmRfZWxfYnlfaWQgaWQgPSBEb2N1bWVudC5maW5kX2VsX2J5X2lkIEcuZG9jdW1lbnQgKEpzdHIudiBpZCkgfD4gT3B0aW9uLmdldFxuXG5sZXQgcnVuX3JvbV9ieXRlcyByb21fYnl0ZXMgZnJhbWVzID1cbiAgbGV0IGNhcnRyaWRnZSA9IERldGVjdF9jYXJ0cmlkZ2UuZiB+cm9tX2J5dGVzIGluXG4gIGxldCBtb2R1bGUgQyA9IENhbWxib3kuTWFrZSh2YWwgY2FydHJpZGdlKSBpblxuICBsZXQgdCA9ICBDLmNyZWF0ZV93aXRoX3JvbSB+cHJpbnRfc2VyaWFsX3BvcnQ6ZmFsc2UgfnJvbV9ieXRlcyBpblxuICBsZXQgZnJhbWVfY291bnQgPSByZWYgMCBpblxuICBsZXQgc3RhcnRfdGltZSA9IHJlZiAoUGVyZm9ybWFuY2Uubm93X21zIEcucGVyZm9ybWFuY2UpIGluXG4gIHdoaWxlICFmcmFtZV9jb3VudCA8IGZyYW1lcyBkb1xuICAgIG1hdGNoIEMucnVuX2luc3RydWN0aW9uIHQgd2l0aFxuICAgIHwgSW5fZnJhbWUgLT4gKClcbiAgICB8IEZyYW1lX2VuZGVkIF8gLT4gaW5jciBmcmFtZV9jb3VudFxuICBkb25lO1xuICAoUGVyZm9ybWFuY2Uubm93X21zIEcucGVyZm9ybWFuY2UpIC0uICFzdGFydF90aW1lXG5cbmxldCBydW5fcm9tX2Jsb2Igcm9tX2Jsb2IgZnJhbWVzID1cbiAgbGV0KiByZXN1bHQgPSBCbG9iLmFycmF5X2J1ZmZlciByb21fYmxvYiBpblxuICBtYXRjaCByZXN1bHQgd2l0aFxuICB8IE9rIGJ1ZiAtPlxuICAgIGxldCByb21fYnl0ZXMgPVxuICAgICAgVGFycmF5Lm9mX2J1ZmZlciBVaW50OCBidWZcbiAgICAgIHw+IFRhcnJheS50b19iaWdhcnJheTFcbiAgICAgICgqIENvbnZlcnQgdWludDggYmlnYXJyYXkgdG8gY2hhciBiaWdhcnJheSAqKVxuICAgICAgfD4gT2JqLm1hZ2ljXG4gICAgaW5cbiAgICBGdXQucmV0dXJuIEBAIHJ1bl9yb21fYnl0ZXMgcm9tX2J5dGVzIGZyYW1lc1xuICB8IEVycm9yIGUgLT5cbiAgICBDb25zb2xlLihsb2cgW0p2LkVycm9yLm1lc3NhZ2UgZV0pO1xuICAgIEZ1dC5yZXR1cm4gMC5cblxubGV0IHJ1bl9yb21fcGF0aCByb21fcGF0aCBmcmFtZXMgPVxuICBsZXQqIHJlc3VsdCA9IEZldGNoLnVybCAoSnN0ci52IHJvbV9wYXRoKSBpblxuICBtYXRjaCByZXN1bHQgd2l0aFxuICB8IE9rIHJlc3BvbnNlIC0+XG4gICAgbGV0IGJvZHkgPSBGZXRjaC5SZXNwb25zZS5hc19ib2R5IHJlc3BvbnNlIGluXG4gICAgbGV0KiByZXN1bHQgPSBGZXRjaC5Cb2R5LmJsb2IgYm9keSBpblxuICAgIGJlZ2luIG1hdGNoIHJlc3VsdCB3aXRoXG4gICAgICB8IE9rIGJsb2IgLT4gcnVuX3JvbV9ibG9iIGJsb2IgZnJhbWVzXG4gICAgICB8IEVycm9yIGUgIC0+IENvbnNvbGUuKGxvZyBbSnYuRXJyb3IubWVzc2FnZSBlXSk7IEZ1dC5yZXR1cm4gMC5cbiAgICBlbmRcbiAgfCBFcnJvciBlICAtPiBDb25zb2xlLihsb2cgW0p2LkVycm9yLm1lc3NhZ2UgZV0pOyBGdXQucmV0dXJuIDAuXG5cbmxldCByZWFkX3BhcmFtIHBhcmFtX2tleSB+ZGVmYXVsdCA9XG4gIGxldCB1cmkgPSBXaW5kb3cubG9jYXRpb24gRy53aW5kb3cgaW5cbiAgbGV0IHBhcmFtID1cbiAgICB1cmlcbiAgICB8PiBVcmkucXVlcnlcbiAgICB8PiBVcmkuUGFyYW1zLm9mX2pzdHJcbiAgaW5cbiAgbWF0Y2ggVXJpLlBhcmFtcy5maW5kIEpzdHIuKHYgcGFyYW1fa2V5KSBwYXJhbSB3aXRoXG4gIHwgU29tZSBqc3RyIC0+IEpzdHIudG9fc3RyaW5nIGpzdHJcbiAgfCBOb25lIC0+IGRlZmF1bHRcblxubGV0ICgpID1cbiAgKCogUmVhZCBVUkwgcGFyYW1ldGVycyAqKVxuICBsZXQgcm9tX3BhdGggPSByZWFkX3BhcmFtIFwicm9tX3BhdGhcIiB+ZGVmYXVsdDpcInRvYnUuZ2JcIiBpblxuICBsZXQgZnJhbWVzID0gcmVhZF9wYXJhbSBcImZyYW1lc1wiIH5kZWZhdWx0OlwiMTUwMFwiIHw+IGludF9vZl9zdHJpbmcgaW5cbiAgKCogTG9hZCBpbml0aWFsIHJvbSAqKVxuICBsZXQgZnV0ID0gcnVuX3JvbV9wYXRoIHJvbV9wYXRoIGZyYW1lcyBpblxuICBGdXQuYXdhaXQgZnV0IChmdW4gZHVyYXRpb25fbXMgLT5cbiAgICAgIGxldCBkdXJhdGlvbiA9IGR1cmF0aW9uX21zIC8uIDEwMDAuIGluXG4gICAgICBsZXQgZnBzID0gRmxvYXQuKG9mX2ludCBmcmFtZXMgLy4gZHVyYXRpb24pIGluXG4gICAgICBsZXQgbXNnID0gUHJpbnRmLnNwcmludGYgXCIlOHM6ICVzXFxuJThzOiAlZFxcbiU4czogJWZcXG4lOHM6ICVmXFxuXCJcbiAgICAgICAgICBcIlJPTSBwYXRoXCIgcm9tX3BhdGhcbiAgICAgICAgICBcIkZyYW1lc1wiIGZyYW1lc1xuICAgICAgICAgIFwiRHVyYXRpb25cIiBkdXJhdGlvblxuICAgICAgICAgIFwiRlBTXCIgZnBzXG4gICAgICBpblxuICAgICAgbGV0IHJlc3VsdF9lbCA9IGZpbmRfZWxfYnlfaWQgXCJiZW5jaF9yZXN1bHRcIiBpblxuICAgICAgRWwuc2V0X2NoaWxkcmVuIHJlc3VsdF9lbCBbRWwudHh0IChKc3RyLnYgbXNnKV0pXG4iXX0=
