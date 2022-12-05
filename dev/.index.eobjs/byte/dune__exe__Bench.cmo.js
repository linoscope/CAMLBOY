(function(globalThis)
   {"use strict";
    var
     runtime=globalThis.jsoo_runtime,
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
     Fut=global_data.Fut,
     Jv=global_data.Jv,
     Brr_io=global_data.Brr_io,
     Camlboy_lib_Detect_cartridge=global_data.Camlboy_lib__Detect_cartridge,
     Camlboy_lib_Camlboy=global_data.Camlboy_lib__Camlboy,
     Stdlib_Option=global_data.Stdlib__Option,
     _a_=
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
    function find_el_by_id(id)
     {var
       _ag_=caml_jsstring_of_string(id),
       _ah_=Brr[16][2],
       _ai_=Brr[10][2],
       _aj_=caml_call2(_ai_,_ah_,_ag_);
      return caml_call1(Stdlib_Option[4],_aj_)}
    function run_rom_bytes(rom_bytes,frames)
     {var
       _Y_=Camlboy_lib_Detect_cartridge[1],
       cartridge=caml_call1(_Y_,rom_bytes),
       C=caml_call1(Camlboy_lib_Camlboy[1],cartridge),
       _Z_=0,
       ___=C[2],
       t=caml_call2(___,_Z_,rom_bytes),
       frame_count=[0,0],
       _$_=Brr[16][4],
       _aa_=Brr[15][9],
       _ab_=caml_call1(_aa_,_$_);
      for(;;)
       {if(frame_count[1] < frames)
         {var _ac_=C[3],match=caml_call1(_ac_,t);
          if(match)frame_count[1]++;
          continue}
        var _ad_=Brr[16][4],_ae_=Brr[15][9],_af_=caml_call1(_ae_,_ad_);
        return _af_ - _ab_}}
    function run_rom_blob(rom_blob,frames)
     {function _M_(result)
       {if(0 === result[0])
         {var
           buf=result[1],
           _P_=0,
           _Q_=0,
           _R_=3,
           _S_=Brr[1][5],
           _T_=caml_call4(_S_,_R_,_Q_,_P_,buf),
           rom_bytes=runtime.caml_ba_from_typed_array(_T_);
          return run_rom_bytes(rom_bytes,frames)}
        var
         e=result[1],
         _U_=0,
         _V_=Jv[30][4],
         _W_=[0,caml_call1(_V_,e),_U_],
         _X_=Brr[12][9];
        caml_call1(_X_,_W_);
        return 0.}
      var _N_=Brr[2][8],_O_=caml_call1(_N_,rom_blob);
      return caml_call2(Fut[15][3],_O_,_M_)}
    function run_rom_path(rom_path,frames)
     {function _w_(result)
       {if(0 === result[0])
         {var
           response=result[1],
           _B_=
            function(result)
             {if(0 === result[0])
               {var blob=result[1];return run_rom_blob(blob,frames)}
              var
               e=result[1],
               _I_=0,
               _J_=Jv[30][4],
               _K_=[0,caml_call1(_J_,e),_I_],
               _L_=Brr[12][9];
              caml_call1(_L_,_K_);
              return caml_call1(Fut[3],0.)},
           _C_=Brr_io[3][1][9],
           _D_=caml_call1(_C_,response);
          return caml_call2(Fut[15][1],_D_,_B_)}
        var
         e=result[1],
         _E_=0,
         _F_=Jv[30][4],
         _G_=[0,caml_call1(_F_,e),_E_],
         _H_=Brr[12][9];
        caml_call1(_H_,_G_);
        return caml_call1(Fut[3],0.)}
      var
       _x_=caml_jsstring_of_string(rom_path),
       _y_=0,
       _z_=Brr_io[3][7],
       _A_=caml_call2(_z_,_y_,_x_);
      return caml_call2(Fut[15][1],_A_,_w_)}
    function read_param(param_key,default$0)
     {var
       _p_=Brr[16][5],
       _q_=Brr[13][12],
       uri=caml_call1(_q_,_p_),
       _r_=Brr[6][6],
       _s_=caml_call1(_r_,uri),
       _t_=Brr[6][9][7],
       param=caml_call1(_t_,_s_),
       _u_=caml_jsstring_of_string(param_key),
       _v_=Brr[6][9][3],
       match=caml_call2(_v_,_u_,param);
      if(match)
       {var jstr=match[1];return runtime.caml_string_of_jsstring(jstr)}
      return default$0}
    function main(param)
     {var
       rom_path=read_param(cst_rom_path,cst_tobu_gb),
       _g_=read_param(cst_frames,cst_1500),
       frames=runtime.caml_int_of_string(_g_);
      function _h_(duration_ms)
       {var
         duration=duration_ms / 1000.,
         fps=frames / duration,
         _j_=Stdlib_Printf[4],
         msg=
          caml_call9
           (_j_,
            _a_,
            cst_ROM_path,
            rom_path,
            cst_Frames,
            frames,
            cst_Duration,
            duration,
            cst_FPS,
            fps),
         result_el=find_el_by_id(cst_bench_result),
         _k_=0,
         _l_=caml_jsstring_of_string(msg),
         _m_=0,
         _n_=Brr[9][2],
         _o_=[0,caml_call2(_n_,_m_,_l_),_k_];
        return caml_call2(Brr[9][18],result_el,_o_)}
      var _i_=run_rom_path(rom_path,frames);
      return caml_call2(Fut[15][3],_i_,_h_)}
    function _b_(_f_){return _f_}
    var _c_=0,_d_=main(_c_),_e_=Fut[2];
    caml_call2(_e_,_d_,_b_);
    var Dune_exe_Bench=[0];
    runtime.caml_register_global(22,Dune_exe_Bench,"Dune__exe__Bench");
    return}
  (globalThis));

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLjAsImZpbGUiOiIuaW5kZXguZW9ianMvYnl0ZS9kdW5lX19leGVfX0JlbmNoLmNtby5qcyIsInNvdXJjZVJvb3QiOiIiLCJuYW1lcyI6WyJmaW5kX2VsX2J5X2lkIiwiaWQiLCJydW5fcm9tX2J5dGVzIiwicm9tX2J5dGVzIiwiZnJhbWVzIiwiY2FydHJpZGdlIiwidCIsImZyYW1lX2NvdW50IiwicnVuX3JvbV9ibG9iIiwicm9tX2Jsb2IiLCJyZXN1bHQiLCJidWYiLCJlIiwicnVuX3JvbV9wYXRoIiwicm9tX3BhdGgiLCJyZXNwb25zZSIsImJsb2IiLCJyZWFkX3BhcmFtIiwicGFyYW1fa2V5IiwiZGVmYXVsdCQwIiwidXJpIiwicGFyYW0iLCJqc3RyIiwibWFpbiIsImR1cmF0aW9uX21zIiwiZHVyYXRpb24iLCJmcHMiLCJtc2ciLCJyZXN1bHRfZWwiXSwic291cmNlcyI6WyIvd29ya3NwYWNlX3Jvb3QvYmluL3dlYi9iZW5jaC5tbCJdLCJtYXBwaW5ncyI6Ijs7STs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7YUFLSUEsY0FBY0M7TUFBdUM7b0NBQXZDQTtPQUF1Qzs7T0FBbEM7OENBQTJEO2FBRTlFQyxjQUFjQyxVQUFVQztNQUMxQjs7T0FBZ0IseUJBREFEO09BQ0Esb0NBQVpFO09BQVk7O09BRVAscUJBSE9GO09BR1A7OztPQUVZOztXQURqQkksaUJBSnNCSDtVQU94QixjQUFNLHNCQUpKRTtVQUlJLFNBRWE7O1FBRXJCO1FBQWtDLG1CQUFlO2FBRS9DRSxhQUFhQyxTQUFTTDtNQUN4QixhQUFLTTtRQUNMLFNBREtBO1VBR0g7ZUFIR0E7V0FHSDs7OztXQUNFLCtCQUZDQztXQUV5QjsrQkFEeEJSLFVBSmtCQztRQVl0QjtXQVhHTTtTQVdIOztTQUFjLHNCQURSRTtTQUNRO1FBQUw7aUJBQ1A7TUFaSixrQkFBYyxtQkFEQ0g7TUFDRCxxQ0FZVjthQUVGSSxhQUFhQyxTQUFTVjtNQUN4QixhQUFLTTtRQUNMLFNBREtBO1VBR0g7b0JBSEdBO1dBR0g7cUJBQ0tBO2NBQ0wsU0FES0E7Z0JBR0QsSUFER00sS0FGRk4sVUFHRCxvQkFER00sS0FQZVo7Y0FVbEI7aUJBTENNO2VBS0Q7O2VBQWMsc0JBRFJFO2VBQ1E7Y0FBTDswQ0FFVjtXQVJIO1dBQ2MsbUJBRlhHO1VBRVc7UUFTZDtXQWJHTDtTQWFIOztTQUFjLHNCQURSRTtTQUNRO1FBQUw7b0NBQ0k7TUFkUzttQ0FEVEU7T0FDUzs7T0FBVjsyQ0FjQzthQUViRyxXQUFXQyxVQUFXQztNQUN4Qjs7O09BQVU7O09BRVIsbUJBRkVDO09BRUY7O09BSTBCLDRCQVBmRjtPQU9lO09BQXRCLHlCQUxGRztNQUtFO1FBQ1MsSUFBUkMsY0FBUSx1Q0FBUkE7TUFDRyxPQVRjSCxTQVNQO2FBRWZJO01BRWE7O09BQ0Y7T0FBbUM7bUJBRTNDQztRQUNVO2tCQURWQTtTQUV5QixJQUoxQnBCLFNBR0FxQjtTQUMwQjtTQUNwQjs7Ozs7WUFOTlg7O1lBQ0FWOztZQUdBcUI7O1lBQ0FDO1NBT1k7O1NBQ2tCLDRCQVA5QkM7U0FPOEI7O1NBQVA7cUNBRHZCQyxjQUMyQztNQVY1QixxQkFIZmQsU0FDQVY7TUFFZSxxQ0FVNEI7c0JBVC9DLFVBUytDO0lBRTlCO0lBQVY7SUFBVTtJQUFWO1UiLCJzb3VyY2VzQ29udGVudCI6WyJvcGVuIENhbWxib3lfbGliXG5vcGVuIEJyclxub3BlbiBCcnJfaW9cbm9wZW4gRnV0LlN5bnRheFxuXG5sZXQgZmluZF9lbF9ieV9pZCBpZCA9IERvY3VtZW50LmZpbmRfZWxfYnlfaWQgRy5kb2N1bWVudCAoSnN0ci52IGlkKSB8PiBPcHRpb24uZ2V0XG5cbmxldCBydW5fcm9tX2J5dGVzIHJvbV9ieXRlcyBmcmFtZXMgPVxuICBsZXQgY2FydHJpZGdlID0gRGV0ZWN0X2NhcnRyaWRnZS5mIH5yb21fYnl0ZXMgaW5cbiAgbGV0IG1vZHVsZSBDID0gQ2FtbGJveS5NYWtlKHZhbCBjYXJ0cmlkZ2UpIGluXG4gIGxldCB0ID0gIEMuY3JlYXRlX3dpdGhfcm9tIH5wcmludF9zZXJpYWxfcG9ydDpmYWxzZSB+cm9tX2J5dGVzIGluXG4gIGxldCBmcmFtZV9jb3VudCA9IHJlZiAwIGluXG4gIGxldCBzdGFydF90aW1lID0gcmVmIChQZXJmb3JtYW5jZS5ub3dfbXMgRy5wZXJmb3JtYW5jZSkgaW5cbiAgd2hpbGUgIWZyYW1lX2NvdW50IDwgZnJhbWVzIGRvXG4gICAgbWF0Y2ggQy5ydW5faW5zdHJ1Y3Rpb24gdCB3aXRoXG4gICAgfCBJbl9mcmFtZSAtPiAoKVxuICAgIHwgRnJhbWVfZW5kZWQgXyAtPiBpbmNyIGZyYW1lX2NvdW50XG4gIGRvbmU7XG4gIChQZXJmb3JtYW5jZS5ub3dfbXMgRy5wZXJmb3JtYW5jZSkgLS4gIXN0YXJ0X3RpbWVcblxubGV0IHJ1bl9yb21fYmxvYiByb21fYmxvYiBmcmFtZXMgPVxuICBsZXQrIHJlc3VsdCA9IEJsb2IuYXJyYXlfYnVmZmVyIHJvbV9ibG9iIGluXG4gIG1hdGNoIHJlc3VsdCB3aXRoXG4gIHwgT2sgYnVmIC0+XG4gICAgbGV0IHJvbV9ieXRlcyA9XG4gICAgICBUYXJyYXkub2ZfYnVmZmVyIFVpbnQ4IGJ1ZlxuICAgICAgfD4gVGFycmF5LnRvX2JpZ2FycmF5MVxuICAgICAgKCogQ29udmVydCB1aW50OCBiaWdhcnJheSB0byBjaGFyIGJpZ2FycmF5ICopXG4gICAgICB8PiBPYmoubWFnaWNcbiAgICBpblxuICAgIHJ1bl9yb21fYnl0ZXMgcm9tX2J5dGVzIGZyYW1lc1xuICB8IEVycm9yIGUgLT5cbiAgICBDb25zb2xlLihsb2cgW0p2LkVycm9yLm1lc3NhZ2UgZV0pO1xuICAgIDAuXG5cbmxldCBydW5fcm9tX3BhdGggcm9tX3BhdGggZnJhbWVzID1cbiAgbGV0KiByZXN1bHQgPSBGZXRjaC51cmwgKEpzdHIudiByb21fcGF0aCkgaW5cbiAgbWF0Y2ggcmVzdWx0IHdpdGhcbiAgfCBPayByZXNwb25zZSAtPlxuICAgIGxldCBib2R5ID0gRmV0Y2guUmVzcG9uc2UuYXNfYm9keSByZXNwb25zZSBpblxuICAgIGxldCogcmVzdWx0ID0gRmV0Y2guQm9keS5ibG9iIGJvZHkgaW5cbiAgICBiZWdpbiBtYXRjaCByZXN1bHQgd2l0aFxuICAgICAgfCBPayBibG9iIC0+XG4gICAgICAgIHJ1bl9yb21fYmxvYiBibG9iIGZyYW1lc1xuICAgICAgfCBFcnJvciBlICAtPlxuICAgICAgICBDb25zb2xlLihsb2cgW0p2LkVycm9yLm1lc3NhZ2UgZV0pO1xuICAgICAgICBGdXQucmV0dXJuIDAuXG4gICAgZW5kXG4gIHwgRXJyb3IgZSAgLT5cbiAgICBDb25zb2xlLihsb2cgW0p2LkVycm9yLm1lc3NhZ2UgZV0pO1xuICAgIEZ1dC5yZXR1cm4gMC5cblxubGV0IHJlYWRfcGFyYW0gcGFyYW1fa2V5IH5kZWZhdWx0ID1cbiAgbGV0IHVyaSA9IFdpbmRvdy5sb2NhdGlvbiBHLndpbmRvdyBpblxuICBsZXQgcGFyYW0gPVxuICAgIHVyaVxuICAgIHw+IFVyaS5xdWVyeVxuICAgIHw+IFVyaS5QYXJhbXMub2ZfanN0clxuICBpblxuICBtYXRjaCBVcmkuUGFyYW1zLmZpbmQgSnN0ci4odiBwYXJhbV9rZXkpIHBhcmFtIHdpdGhcbiAgfCBTb21lIGpzdHIgLT4gSnN0ci50b19zdHJpbmcganN0clxuICB8IE5vbmUgLT4gZGVmYXVsdFxuXG5sZXQgbWFpbiAoKSA9XG4gICgqIFJlYWQgVVJMIHBhcmFtZXRlcnMgKilcbiAgbGV0IHJvbV9wYXRoID0gcmVhZF9wYXJhbSBcInJvbV9wYXRoXCIgfmRlZmF1bHQ6XCJ0b2J1LmdiXCIgaW5cbiAgbGV0IGZyYW1lcyA9IHJlYWRfcGFyYW0gXCJmcmFtZXNcIiB+ZGVmYXVsdDpcIjE1MDBcIiB8PiBpbnRfb2Zfc3RyaW5nIGluXG4gICgqIExvYWQgaW5pdGlhbCByb20gKilcbiAgbGV0KyBkdXJhdGlvbl9tcyA9IHJ1bl9yb21fcGF0aCByb21fcGF0aCBmcmFtZXMgaW5cbiAgbGV0IGR1cmF0aW9uID0gZHVyYXRpb25fbXMgLy4gMTAwMC4gaW5cbiAgbGV0IGZwcyA9IEZsb2F0LihvZl9pbnQgZnJhbWVzIC8uIGR1cmF0aW9uKSBpblxuICBsZXQgbXNnID0gUHJpbnRmLnNwcmludGYgXCIlOHM6ICVzXFxuJThzOiAlZFxcbiU4czogJWZcXG4lOHM6ICVmXFxuXCJcbiAgICAgIFwiUk9NIHBhdGhcIiByb21fcGF0aFxuICAgICAgXCJGcmFtZXNcIiBmcmFtZXNcbiAgICAgIFwiRHVyYXRpb25cIiBkdXJhdGlvblxuICAgICAgXCJGUFNcIiBmcHNcbiAgaW5cbiAgbGV0IHJlc3VsdF9lbCA9IGZpbmRfZWxfYnlfaWQgXCJiZW5jaF9yZXN1bHRcIiBpblxuICBFbC5zZXRfY2hpbGRyZW4gcmVzdWx0X2VsIFtFbC50eHQgKEpzdHIudiBtc2cpXVxuXG5sZXQgKCkgPSBGdXQuYXdhaXQgKG1haW4gKCkpIEZ1bi5pZFxuIl19
