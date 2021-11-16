(function(joo_global_object)
   {"use strict";
    var
     runtime=joo_global_object.jsoo_runtime,
     caml_check_bound=runtime.caml_check_bound,
     caml_jsstring_of_string=runtime.caml_jsstring_of_string,
     caml_string_notequal=runtime.caml_string_notequal,
     caml_string_of_jsbytes=runtime.caml_string_of_jsbytes,
     caml_string_of_jsstring=runtime.caml_string_of_jsstring;
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
    var
     global_data=runtime.caml_get_global_data(),
     cst_fps=caml_string_of_jsbytes("fps"),
     cst_right=caml_string_of_jsbytes("right"),
     cst_left=caml_string_of_jsbytes("left"),
     cst_down=caml_string_of_jsbytes("down"),
     cst_up=caml_string_of_jsbytes("up"),
     cst_b=caml_string_of_jsbytes("b"),
     cst_a$1=caml_string_of_jsbytes("a"),
     cst_select=caml_string_of_jsbytes("select"),
     cst_start=caml_string_of_jsbytes("start"),
     cst_Enter$0=caml_string_of_jsbytes("Enter"),
     cst_Shift$0=caml_string_of_jsbytes("Shift"),
     cst_a$0=caml_string_of_jsbytes("a"),
     cst_d$0=caml_string_of_jsbytes("d"),
     cst_j$0=caml_string_of_jsbytes("j"),
     cst_k$0=caml_string_of_jsbytes("k"),
     cst_s$0=caml_string_of_jsbytes("s"),
     cst_w$0=caml_string_of_jsbytes("w"),
     cst_Enter=caml_string_of_jsbytes("Enter"),
     cst_Shift=caml_string_of_jsbytes("Shift"),
     cst_a=caml_string_of_jsbytes("a"),
     cst_d=caml_string_of_jsbytes("d"),
     cst_j=caml_string_of_jsbytes("j"),
     cst_k=caml_string_of_jsbytes("k"),
     cst_s=caml_string_of_jsbytes("s"),
     cst_w=caml_string_of_jsbytes("w"),
     rom_options=
      [0,
       [0,
        caml_string_of_jsbytes("The Bouncing Ball"),
        caml_string_of_jsbytes("./the-bouncing-ball.gb")],
       [0,
        [0,
         caml_string_of_jsbytes("Tobu Tobu Girl"),
         caml_string_of_jsbytes("./tobu.gb")],
        [0,
         [0,
          caml_string_of_jsbytes("Cavern"),
          caml_string_of_jsbytes("./cavern.gb")],
         [0,
          [0,
           caml_string_of_jsbytes("Into The Blue"),
           caml_string_of_jsbytes("./into-the-blue.gb")],
          [0,
           [0,
            caml_string_of_jsbytes("Rocket Man Demo"),
            caml_string_of_jsbytes("./rocket-man-demo.gb")],
           [0,
            [0,
             caml_string_of_jsbytes("Retroid"),
             caml_string_of_jsbytes("./retroid.gb")],
            [0,
             [0,
              caml_string_of_jsbytes("Wishing Sarah"),
              caml_string_of_jsbytes("./dreaming-sarah.gb")],
             [0,
              [0,
               caml_string_of_jsbytes("SHEEP IT UP"),
               caml_string_of_jsbytes("./sheep-it-up.gb")],
              0]]]]]]]],
     cst_canvas=caml_string_of_jsbytes("canvas"),
     cst_throttle=caml_string_of_jsbytes("throttle"),
     cst_load_rom=caml_string_of_jsbytes("load-rom"),
     cst_rom_selector=caml_string_of_jsbytes("rom-selector"),
     Brr=global_data.Brr,
     Fut=global_data.Fut,
     Stdlib_List=global_data.Stdlib__List,
     Jv=global_data.Jv,
     Brr_io=global_data.Brr_io,
     Stdlib_Printf=global_data.Stdlib__Printf,
     Camlboy_lib_Detect_cartridge=global_data.Camlboy_lib__Detect_cartridge,
     Camlboy_lib_Camlboy=global_data.Camlboy_lib__Camlboy,
     Dune_exe_My_ev=global_data.Dune__exe__My_ev,
     Brr_canvas=global_data.Brr_canvas,
     Stdlib_Option=global_data.Stdlib__Option,
     Stdlib_Array=global_data.Stdlib__Array,
     _b_=[0,[8,[0,0,0],0,[0,1],0],caml_string_of_jsbytes("%.1f")],
     _a_=[0,1],
     gb_w=160,
     gb_h=144;
    function alert(v)
     {var alert=Jv[12].alert;alert(caml_call1(Jv[23],v));return 0}
    function console_log(s)
     {return caml_call1(Brr[12][9],[0,caml_jsstring_of_string(s),0])}
    function viberate(ms)
     {var navigator=Brr[16][3];navigator.vibrate(ms);return 0}
    function find_el_by_id(id)
     {var _$_=caml_call2(Brr[10][2],Brr[16][2],caml_jsstring_of_string(id));
      return caml_call1(Stdlib_Option[4],_$_)}
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
            {d[off] = 97;
             d[off + 1 | 0] = 104;
             d[off + 2 | 0] = 125;
             d[off + 3 | 0] = 255}
           else
            {d[off] = 229;
             d[off + 1 | 0] = 251;
             d[off + 2 | 0] = 244;
             d[off + 3 | 0] = 255}
          else
           if(-603547828 <= match)
            {d[off] = 151;
             d[off + 1 | 0] = 174;
             d[off + 2 | 0] = 184;
             d[off + 3 | 0] = 255}
           else
            {d[off] = 34;
             d[off + 1 | 0] = 30;
             d[off + 2 | 0] = 49;
             d[off + 3 | 0] = 255}
          var ___=x + 1 | 0;
          if(159 !== x){var x=___;continue}
          var _Z_=y + 1 | 0;
          if(143 !== y){var y=_Z_;continue a}
          return caml_call4(Brr_canvas[4][93],ctx,image_data,0,0)}}}
    var run_id=[0,0],key_down_listener=[0,0],key_up_listener=[0,0];
    function set_listener(down,up)
     {key_down_listener[1] = [0,down];key_up_listener[1] = [0,up];return 0}
    function clear(param)
     {var _W_=run_id[1];
      if(_W_)
       {var timer_id=_W_[1];
        caml_call1(Brr[16][10],timer_id);
        caml_call1(Brr[16][12],timer_id)}
      var _X_=key_down_listener[1];
      if(_X_)
       {var lister=_X_[1];
        caml_call4(Brr[7][21],0,Brr[7][76],lister,Brr[16][6])}
      var _Y_=key_up_listener[1];
      if(_Y_)
       {var lister$0=_Y_[1];
        return caml_call4(Brr[7][21],0,Brr[7][77],lister$0,Brr[16][6])}
      return 0}
    var State=[0,run_id,key_down_listener,key_up_listener,set_listener,clear];
    function set_up_keyboard(C)
     {return function(t)
       {function key_down_listener(ev)
         {var key_name=caml_string_of_jsstring(caml_call1(Brr[7][31][2],ev));
          return caml_string_notequal(key_name,cst_Enter)
                  ?caml_string_notequal(key_name,cst_Shift)
                    ?caml_string_notequal(key_name,cst_a)
                      ?caml_string_notequal(key_name,cst_d)
                        ?caml_string_notequal(key_name,cst_j)
                          ?caml_string_notequal(key_name,cst_k)
                            ?caml_string_notequal(key_name,cst_s)
                              ?caml_string_notequal(key_name,cst_w)?0:caml_call2(C[4],t,1)
                              :caml_call2(C[4],t,0)
                            :caml_call2(C[4],t,7)
                          :caml_call2(C[4],t,6)
                        :caml_call2(C[4],t,3)
                      :caml_call2(C[4],t,2)
                    :caml_call2(C[4],t,5)
                  :caml_call2(C[4],t,4)}
        function key_up_listener(ev)
         {var key_name=caml_string_of_jsstring(caml_call1(Brr[7][31][2],ev));
          return caml_string_notequal(key_name,cst_Enter$0)
                  ?caml_string_notequal(key_name,cst_Shift$0)
                    ?caml_string_notequal(key_name,cst_a$0)
                      ?caml_string_notequal(key_name,cst_d$0)
                        ?caml_string_notequal(key_name,cst_j$0)
                          ?caml_string_notequal(key_name,cst_k$0)
                            ?caml_string_notequal(key_name,cst_s$0)
                              ?caml_string_notequal(key_name,cst_w$0)
                                ?0
                                :caml_call2(C[5],t,1)
                              :caml_call2(C[5],t,0)
                            :caml_call2(C[5],t,7)
                          :caml_call2(C[5],t,6)
                        :caml_call2(C[5],t,3)
                      :caml_call2(C[5],t,2)
                    :caml_call2(C[5],t,5)
                  :caml_call2(C[5],t,4)}
        caml_call4(Brr[7][20],0,Brr[7][76],key_down_listener,Brr[16][6]);
        caml_call4(Brr[7][20],0,Brr[7][77],key_up_listener,Brr[16][6]);
        return caml_call2(State[4],key_down_listener,key_up_listener)}}
    function set_up_joypad(C)
     {return function(t)
       {var
         right_el=find_el_by_id(cst_right),
         left_el=find_el_by_id(cst_left),
         down_el=find_el_by_id(cst_down),
         up_el=find_el_by_id(cst_up),
         b_el=find_el_by_id(cst_b),
         a_el=find_el_by_id(cst_a$1),
         select_el=find_el_by_id(cst_select),
         start_el=find_el_by_id(cst_start);
        function press(ev,t,key)
         {caml_call1(Brr[7][13],ev);
          viberate(10);
          return caml_call2(C[4],t,key)}
        function release(ev,t,key)
         {caml_call1(Brr[7][13],ev);return caml_call2(C[5],t,key)}
        var listen_ops=caml_call4(Brr[7][19],_a_,0,0,0);
        function _G_(ev){return press(ev,t,1)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[2],_G_,up_el);
        function _H_(ev){return press(ev,t,0)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[2],_H_,down_el);
        function _I_(ev){return press(ev,t,2)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[2],_I_,left_el);
        function _J_(ev){return press(ev,t,3)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[2],_J_,right_el);
        function _K_(ev){return press(ev,t,7)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[2],_K_,a_el);
        function _L_(ev){return press(ev,t,6)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[2],_L_,b_el);
        function _M_(ev){return press(ev,t,4)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[2],_M_,start_el);
        function _N_(ev){return press(ev,t,5)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[2],_N_,select_el);
        function _O_(ev){return release(ev,t,1)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[3],_O_,up_el);
        function _P_(ev){return release(ev,t,0)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[3],_P_,down_el);
        function _Q_(ev){return release(ev,t,2)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[3],_Q_,left_el);
        function _R_(ev){return release(ev,t,3)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[3],_R_,right_el);
        function _S_(ev){return release(ev,t,7)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[3],_S_,a_el);
        function _T_(ev){return release(ev,t,6)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[3],_T_,b_el);
        function _U_(ev){return release(ev,t,4)}
        caml_call4(Brr[7][20],[0,listen_ops],Dune_exe_My_ev[3],_U_,start_el);
        function _V_(ev){return release(ev,t,5)}
        return caml_call4
                (Brr[7][20],[0,listen_ops],Dune_exe_My_ev[3],_V_,select_el)}}
    var throttled=[0,1];
    function run_rom_bytes(ctx,image_data,rom_bytes)
     {caml_call1(State[5],0);
      var
       cartridge=caml_call1(Camlboy_lib_Detect_cartridge[1],rom_bytes),
       C=caml_call1(Camlboy_lib_Camlboy[1],cartridge),
       t=caml_call2(C[2],1,rom_bytes);
      caml_call1(set_up_keyboard(C),t);
      caml_call1(set_up_joypad(C),t);
      var cnt=[0,0],start_time=[0,caml_call1(Brr[15][9],Brr[16][4])];
      function main_loop(param)
       {for(;;)
         {var match=caml_call1(C[3],t);
          if(match)
           {var fb=match[1];
            cnt[1]++;
            if(60 === cnt[1])
             {var
               end_time=caml_call1(Brr[15][9],Brr[16][4]),
               sec_per_60_frame=(end_time - start_time[1]) / 1000.,
               fps=60. / sec_per_60_frame;
              start_time[1] = end_time;
              var
               fps_str=caml_call2(Stdlib_Printf[4],_b_,fps),
               fps_el=find_el_by_id(cst_fps),
               _C_=
                [0,caml_call2(Brr[9][2],0,caml_jsstring_of_string(fps_str)),0];
              caml_call2(Brr[9][18],fps_el,_C_);
              cnt[1] = 0}
            draw_framebuffer(ctx,image_data,fb);
            if(throttled[1])
             {var
               _D_=function(param){return main_loop(0)},
               _E_=[0,caml_call1(Brr[16][11],_D_)];
              State[1][1] = _E_;
              return 0}
            var _F_=[0,caml_call2(Brr[16][8],0,main_loop)];
            State[1][1] = _F_;
            return 0}
          continue}}
      return main_loop(0)}
    function run_rom_blob(ctx,image_data,rom_blob)
     {function _x_(result)
       {if(0 === result[0])
         {var
           buf=result[1],
           rom_bytes=
            runtime.caml_ba_from_typed_array(caml_call4(Brr[1][5],3,0,0,buf)),
           _z_=run_rom_bytes(ctx,image_data,rom_bytes);
          return caml_call1(Fut[3],_z_)}
        var
         e=result[1],
         _A_=[0,caml_call1(Jv[30][4],e),0],
         _B_=caml_call1(Brr[12][9],_A_);
        return caml_call1(Fut[3],_B_)}
      var _y_=caml_call1(Brr[2][8],rom_blob);
      return caml_call2(Fut[15][1],_y_,_x_)}
    function on_load_rom(ctx,image_data,input_el)
     {var
       _u_=caml_call1(Brr[9][56][1],input_el),
       file=caml_call1(Stdlib_List[5],_u_);
      function _v_(param){return 0}
      var _w_=run_rom_blob(ctx,image_data,file);
      return caml_call2(Fut[2],_w_,_v_)}
    function run_selected_rom(ctx,image_data,rom_path)
     {function _m_(result)
       {if(0 === result[0])
         {var
           response=result[1],
           _o_=
            function(result)
             {if(0 === result[0])
               {var blob=result[1];return run_rom_blob(ctx,image_data,blob)}
              var
               e=result[1],
               _s_=[0,caml_call1(Jv[30][4],e),0],
               _t_=caml_call1(Brr[12][9],_s_);
              return caml_call1(Fut[3],_t_)},
           _p_=caml_call1(Brr_io[3][1][9],response);
          return caml_call2(Fut[15][1],_p_,_o_)}
        var
         e=result[1],
         _q_=[0,caml_call1(Jv[30][4],e),0],
         _r_=caml_call1(Brr[12][9],_q_);
        return caml_call1(Fut[3],_r_)}
      var _n_=caml_call2(Brr_io[3][7],0,caml_jsstring_of_string(rom_path));
      return caml_call2(Fut[15][1],_n_,_m_)}
    function set_up_rom_selector(ctx,image_data,selector_el)
     {function _g_(rom_option)
       {var
         _k_=[0,caml_call2(Brr[9][3],0,rom_option[1]),0],
         _l_=
          [0,
           [0,caml_call1(Brr[8][37],caml_jsstring_of_string(rom_option[2])),0]];
        return caml_call3(Brr[9][127],0,_l_,_k_)}
      var _h_=caml_call1(caml_call1(Stdlib_List[19],_g_),rom_options);
      caml_call1(caml_call1(Brr[9][20],selector_el),_h_);
      function on_change(param)
       {var
         rom_path=
          caml_string_of_jsstring
           (caml_call2(Brr[9][26],Brr[9][25][10],selector_el));
        function _i_(param){return 0}
        var _j_=run_selected_rom(ctx,image_data,rom_path);
        return caml_call2(Fut[2],_j_,_i_)}
      return caml_call4(Brr[7][20],0,Brr[7][43],on_change,selector_el)}
    function on_checkbox_change(checkbox_el)
     {var checked=caml_call2(Brr[9][26],Brr[9][25][5],checkbox_el);
      throttled[1] = checked;
      return 0}
    var
     _c_=find_el_by_id(cst_canvas),
     canvas=caml_call1(Brr_canvas[3][2],_c_),
     ctx=caml_call2(Brr_canvas[4][15],0,canvas);
    caml_call3(Brr_canvas[4][36],ctx,1.5,1.5);
    var
     image_data=caml_call3(Brr_canvas[4][91],ctx,gb_w,gb_h),
     fb=caml_call3(Stdlib_Array[3],gb_h,gb_w,-603547828);
    draw_framebuffer(ctx,image_data,fb);
    var checkbox_el=find_el_by_id(cst_throttle);
    function _d_(param){return on_checkbox_change(checkbox_el)}
    caml_call4(Brr[7][20],0,Brr[7][43],_d_,checkbox_el);
    var input_el=find_el_by_id(cst_load_rom);
    function _e_(param){return on_load_rom(ctx,image_data,input_el)}
    caml_call4(Brr[7][20],0,Brr[7][43],_e_,input_el);
    var selector_el=find_el_by_id(cst_rom_selector);
    set_up_rom_selector(ctx,image_data,selector_el);
    var
     rom=caml_call1(Stdlib_List[5],rom_options),
     fut=run_selected_rom(ctx,image_data,rom[2]);
    function _f_(param){return 0}
    caml_call2(Fut[2],fut,_f_);
    var
     Dune_exe_Index=
      [0,
       gb_w,
       gb_h,
       rom_options,
       alert,
       console_log,
       viberate,
       find_el_by_id,
       draw_framebuffer,
       State,
       set_up_keyboard,
       set_up_joypad,
       throttled,
       run_rom_bytes,
       run_rom_blob,
       on_load_rom,
       run_selected_rom,
       set_up_rom_selector,
       on_checkbox_change];
    runtime.caml_register_global(50,Dune_exe_Index,"Dune__exe__Index");
    return}
  (function(){return this}()));

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLjAsImZpbGUiOiIuaW5kZXguZW9ianMvYnl0ZS9kdW5lX19leGVfX0luZGV4LmNtby5qcyIsInNvdXJjZVJvb3QiOiIiLCJuYW1lcyI6WyJyb21fb3B0aW9ucyIsImdiX3ciLCJnYl9oIiwiYWxlcnQiLCJ2IiwiY29uc29sZV9sb2ciLCJzIiwidmliZXJhdGUiLCJtcyIsIm5hdmlnYXRvciIsImZpbmRfZWxfYnlfaWQiLCJpZCIsImRyYXdfZnJhbWVidWZmZXIiLCJjdHgiLCJpbWFnZV9kYXRhIiwiZmIiLCJkIiwieSIsIngiLCJvZmYiLCJydW5faWQiLCJrZXlfZG93bl9saXN0ZW5lciIsImtleV91cF9saXN0ZW5lciIsInNldF9saXN0ZW5lciIsImRvd24iLCJ1cCIsImNsZWFyIiwidGltZXJfaWQiLCJsaXN0ZXIiLCJsaXN0ZXIkMCIsInNldF91cF9rZXlib2FyZCIsIkMiLCJ0IiwiZXYiLCJrZXlfbmFtZSIsInNldF91cF9qb3lwYWQiLCJyaWdodF9lbCIsImxlZnRfZWwiLCJkb3duX2VsIiwidXBfZWwiLCJiX2VsIiwiYV9lbCIsInNlbGVjdF9lbCIsInN0YXJ0X2VsIiwicHJlc3MiLCJrZXkiLCJyZWxlYXNlIiwibGlzdGVuX29wcyIsInRocm90dGxlZCIsInJ1bl9yb21fYnl0ZXMiLCJyb21fYnl0ZXMiLCJjYXJ0cmlkZ2UiLCJjbnQiLCJzdGFydF90aW1lIiwibWFpbl9sb29wIiwiZW5kX3RpbWUiLCJzZWNfcGVyXzYwX2ZyYW1lIiwiZnBzIiwiZnBzX3N0ciIsImZwc19lbCIsInJ1bl9yb21fYmxvYiIsInJvbV9ibG9iIiwicmVzdWx0IiwiYnVmIiwiZSIsIm9uX2xvYWRfcm9tIiwiaW5wdXRfZWwiLCJmaWxlIiwicnVuX3NlbGVjdGVkX3JvbSIsInJvbV9wYXRoIiwicmVzcG9uc2UiLCJibG9iIiwic2V0X3VwX3JvbV9zZWxlY3RvciIsInNlbGVjdG9yX2VsIiwicm9tX29wdGlvbiIsIm9uX2NoYW5nZSIsIm9uX2NoZWNrYm94X2NoYW5nZSIsImNoZWNrYm94X2VsIiwiY2hlY2tlZCIsImNhbnZhcyIsInJvbSIsImZ1dCJdLCJzb3VyY2VzIjpbIi9ob21lL3J1bm5lci93b3JrL0NBTUxCT1kvQ0FNTEJPWS9fYnVpbGQvZGVmYXVsdC9iaW4vd2ViL2luZGV4Lm1sIl0sIm1hcHBpbmdzIjoiOztJOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztLQVdJQTs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7OztLQUpBQztLQUNBQzthQWNBQyxNQUFNQztNQUNJLElBQVJELG1CQUNNLE1BQXFCLGtCQUZ2QkMsSUFFRSxRQUFtQzthQUUzQ0MsWUFBWUM7TUFBc0Isd0RBQXRCQSxNQUFrQzthQUU5Q0MsU0FBU0M7TUFDWCxJQUFJQyxxQkFDTSxrQkFGQ0QsSUFFRCxRQUE4QzthQUV0REUsY0FBY0M7TUFBSyx5Q0FBa0Msd0JBQXZDQTtNQUFLLHVDQUEyRDthQUU5RUMsaUJBQWlCQyxJQUFJQyxXQUFXQztNQUMxQixzQ0FEZUQsWUFFdkJHOztNQUNFOztRQUNFOztxQkFGSkEsZUFDRUM7V0FFYyx1QkFBTixpQkFMd0JILEdBRWxDRSxVQUNFQztVQUVjOzthQVlWLEVBYkVDO2FBY0YsRUFkRUE7YUFlRixFQWZFQTthQWdCRixFQWhCRUE7O2FBR0YsRUFIRUE7YUFJRixFQUpFQTthQUtGLEVBTEVBO2FBTUYsRUFORUE7OzthQVFGLEVBUkVBO2FBU0YsRUFURUE7YUFVRixFQVZFQTthQVdGLEVBWEVBOzthQWtCRixFQWxCRUE7YUFtQkYsRUFuQkVBO2FBb0JGLEVBcEJFQTthQXFCRixFQXJCRUE7VUFBSixRQURGRDs7VUFDRSxRQUZKRDs7VUEwQkEsb0NBNUJtQkosSUFBSUMsaUJBNEJvQjtRQUl2Q00sYUFDQUMsd0JBQ0FDO2FBQ0FDLGFBQWFDLEtBQUtDO01BQ3BCLDBCQURlRCxNQUNmLHdCQURvQkMsSUFDcEIsUUFDMEI7YUFDeEJDO01BQ0YsUUFQRU47TUFPRjtRQUdJLElBREtPO1FBQ0wsdUJBREtBO1FB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bm9wZW4gQnJyX2NhbnZhc1xub3BlbiBCcnJfaW9cbm9wZW4gRnV0LlN5bnRheFxuXG5cbmxldCBnYl93ID0gMTYwXG5sZXQgZ2JfaCA9IDE0NFxuXG50eXBlIHJvbV9vcHRpb24gPSB7bmFtZSA6IHN0cmluZzsgcGF0aCA6IHN0cmluZ31cbmxldCByb21fb3B0aW9ucyA9IFtcbiAge25hbWUgPSBcIlRoZSBCb3VuY2luZyBCYWxsXCIgOyBwYXRoID0gXCIuL3RoZS1ib3VuY2luZy1iYWxsLmdiXCJ9O1xuICB7bmFtZSA9IFwiVG9idSBUb2J1IEdpcmxcIiAgICA7IHBhdGggPSBcIi4vdG9idS5nYlwifTtcbiAge25hbWUgPSBcIkNhdmVyblwiICAgICAgICAgICAgOyBwYXRoID0gXCIuL2NhdmVybi5nYlwifTtcbiAge25hbWUgPSBcIkludG8gVGhlIEJsdWVcIiAgICAgOyBwYXRoID0gXCIuL2ludG8tdGhlLWJsdWUuZ2JcIn07XG4gIHtuYW1lID0gXCJSb2NrZXQgTWFuIERlbW9cIiAgIDsgcGF0aCA9IFwiLi9yb2NrZXQtbWFuLWRlbW8uZ2JcIn07XG4gIHtuYW1lID0gXCJSZXRyb2lkXCIgICAgICAgICAgIDsgcGF0aCA9IFwiLi9yZXRyb2lkLmdiXCJ9O1xuICB7bmFtZSA9IFwiV2lzaGluZyBTYXJhaFwiICAgICA7IHBhdGggPSBcIi4vZHJlYW1pbmctc2FyYWguZ2JcIn07XG4gIHtuYW1lID0gXCJTSEVFUCBJVCBVUFwiICAgICAgIDsgcGF0aCA9IFwiLi9zaGVlcC1pdC11cC5nYlwifTtcbl1cblxubGV0IGFsZXJ0IHYgPVxuICBsZXQgYWxlcnQgPSBKdi5nZXQgSnYuZ2xvYmFsIFwiYWxlcnRcIiBpblxuICBpZ25vcmUgQEAgSnYuYXBwbHkgYWxlcnQgSnYuW3wgb2Zfc3RyaW5nIHYgfF1cblxubGV0IGNvbnNvbGVfbG9nIHMgPSBDb25zb2xlLmxvZyBKc3RyLltvZl9zdHJpbmcgc11cblxubGV0IHZpYmVyYXRlIG1zID1cbiAgbGV0IG5hdmlnYXRvciA9IEcubmF2aWdhdG9yIHw+IE5hdmlnYXRvci50b19qdiBpblxuICBpZ25vcmUgQEAgSnYuY2FsbCBuYXZpZ2F0b3IgXCJ2aWJyYXRlXCIgSnYuW3wgb2ZfaW50IG1zIHxdXG5cbmxldCBmaW5kX2VsX2J5X2lkIGlkID0gRG9jdW1lbnQuZmluZF9lbF9ieV9pZCBHLmRvY3VtZW50IChKc3RyLnYgaWQpIHw+IE9wdGlvbi5nZXRcblxubGV0IGRyYXdfZnJhbWVidWZmZXIgY3R4IGltYWdlX2RhdGEgZmIgPVxuICBsZXQgZCA9IEMyZC5JbWFnZV9kYXRhLmRhdGEgaW1hZ2VfZGF0YSBpblxuICBmb3IgeSA9IDAgdG8gZ2JfaCAtIDEgZG9cbiAgICBmb3IgeCA9IDAgdG8gZ2JfdyAtIDEgZG9cbiAgICAgIGxldCBvZmYgPSA0ICogKHkgKiBnYl93ICsgeCkgaW5cbiAgICAgIG1hdGNoIGZiLih5KS4oeCkgd2l0aFxuICAgICAgfCBgV2hpdGUgLT5cbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgICAgKSAweEU1O1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDEpIDB4RkI7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMikgMHhGNDtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAzKSAweEZGO1xuICAgICAgfCBgTGlnaHRfZ3JheSAtPlxuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiAgICApIDB4OTc7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMSkgMHhBRTtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAyKSAweEI4O1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDMpIDB4RkY7XG4gICAgICB8IGBEYXJrX2dyYXkgLT5cbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgICAgKSAweDYxO1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDEpIDB4Njg7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMikgMHg3RDtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAzKSAweEZGO1xuICAgICAgfCBgQmxhY2sgLT5cbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgICAgKSAweDIyO1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDEpIDB4MUU7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMikgMHgzMTtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAzKSAweEZGO1xuICAgIGRvbmVcbiAgZG9uZTtcbiAgQzJkLnB1dF9pbWFnZV9kYXRhIGN0eCBpbWFnZV9kYXRhIH54OjAgfnk6MFxuXG4oKiogTWFuYWdlcyBzdGF0ZSB0aGF0IG5lZWQgdG8gYmUgcmVzZXQgd2hlbiBsb2FkaW5nIGEgbmV3IHJvbSAqKVxubW9kdWxlIFN0YXRlID0gc3RydWN0XG4gIGxldCBydW5faWQgPSByZWYgTm9uZVxuICBsZXQga2V5X2Rvd25fbGlzdGVuZXIgPSByZWYgTm9uZVxuICBsZXQga2V5X3VwX2xpc3RlbmVyID0gcmVmIE5vbmVcbiAgbGV0IHNldF9saXN0ZW5lciBkb3duIHVwID1cbiAgICBrZXlfZG93bl9saXN0ZW5lciA6PSBTb21lIGRvd247XG4gICAga2V5X3VwX2xpc3RlbmVyIDo9IFNvbWUgdXBcbiAgbGV0IGNsZWFyICgpID1cbiAgICBiZWdpbiBtYXRjaCAhcnVuX2lkIHdpdGhcbiAgICAgIHwgTm9uZSAtPiAoKVxuICAgICAgfCBTb21lIHRpbWVyX2lkIC0+XG4gICAgICAgIEcuc3RvcF90aW1lciB0aW1lcl9pZDtcbiAgICAgICAgRy5jYW5jZWxfYW5pbWF0aW9uX2ZyYW1lIHRpbWVyX2lkO1xuICAgIGVuZDtcbiAgICBiZWdpbiBtYXRjaCAha2V5X2Rvd25fbGlzdGVuZXIgd2l0aFxuICAgICAgfCBOb25lIC0+ICgpXG4gICAgICB8IFNvbWUgbGlzdGVyIC0+IEV2LnVubGlzdGVuIEV2LmtleWRvd24gbGlzdGVyIEcudGFyZ2V0XG4gICAgZW5kO1xuICAgIGJlZ2luIG1hdGNoICFrZXlfdXBfbGlzdGVuZXIgd2l0aFxuICAgICAgfCBOb25lIC0+ICgpXG4gICAgICB8IFNvbWUgbGlzdGVyIC0+IEV2LnVubGlzdGVuIEV2LmtleXVwIGxpc3RlciBHLnRhcmdldFxuICAgIGVuZFxuZW5kXG5cbmxldCBzZXRfdXBfa2V5Ym9hcmQgKHR5cGUgYSkgKG1vZHVsZSBDIDogQ2FtbGJveV9pbnRmLlMgd2l0aCB0eXBlIHQgPSBhKSAodCA6IGEpID1cbiAgbGV0IGtleV9kb3duX2xpc3RlbmVyIGV2ID1cbiAgICBsZXQga2V5X2V2ID0gRXYuYXNfdHlwZSBldiBpblxuICAgIGxldCBrZXlfbmFtZSA9IGtleV9ldiB8PiBFdi5LZXlib2FyZC5rZXkgfD4gSnN0ci50b19zdHJpbmcgaW5cbiAgICBtYXRjaCBrZXlfbmFtZSB3aXRoXG4gICAgfCBcIkVudGVyXCIgLT4gQy5wcmVzcyB0IFN0YXJ0XG4gICAgfCBcIlNoaWZ0XCIgLT4gQy5wcmVzcyB0IFNlbGVjdFxuICAgIHwgXCJqXCIgICAgIC0+IEMucHJlc3MgdCBCXG4gICAgfCBcImtcIiAgICAgLT4gQy5wcmVzcyB0IEFcbiAgICB8IFwid1wiICAgICAtPiBDLnByZXNzIHQgVXBcbiAgICB8IFwiYVwiICAgICAtPiBDLnByZXNzIHQgTGVmdFxuICAgIHwgXCJzXCIgICAgIC0+IEMucHJlc3MgdCBEb3duXG4gICAgfCBcImRcIiAgICAgLT4gQy5wcmVzcyB0IFJpZ2h0XG4gICAgfCBfICAgICAgIC0+ICgpXG4gIGluXG4gIGxldCBrZXlfdXBfbGlzdGVuZXIgZXYgPVxuICAgIGxldCBrZXlfZXYgPSBFdi5hc190eXBlIGV2IGluXG4gICAgbGV0IGtleV9uYW1lID0ga2V5X2V2IHw+IEV2LktleWJvYXJkLmtleSB8PiBKc3RyLnRvX3N0cmluZyBpblxuICAgIG1hdGNoIGtleV9uYW1lIHdpdGhcbiAgICB8IFwiRW50ZXJcIiAtPiBDLnJlbGVhc2UgdCBTdGFydFxuICAgIHwgXCJTaGlmdFwiIC0+IEMucmVsZWFzZSB0IFNlbGVjdFxuICAgIHwgXCJqXCIgICAgIC0+IEMucmVsZWFzZSB0IEJcbiAgICB8IFwia1wiICAgICAtPiBDLnJlbGVhc2UgdCBBXG4gICAgfCBcIndcIiAgICAgLT4gQy5yZWxlYXNlIHQgVXBcbiAgICB8IFwiYVwiICAgICAtPiBDLnJlbGVhc2UgdCBMZWZ0XG4gICAgfCBcInNcIiAgICAgLT4gQy5yZWxlYXNlIHQgRG93blxuICAgIHwgXCJkXCIgICAgIC0+IEMucmVsZWFzZSB0IFJpZ2h0XG4gICAgfCBfICAgICAgIC0+ICgpXG4gIGluXG4gIEV2Lmxpc3RlbiBFdi5rZXlkb3duIChrZXlfZG93bl9saXN0ZW5lcikgRy50YXJnZXQ7XG4gIEV2Lmxpc3RlbiBFdi5rZXl1cCAoa2V5X3VwX2xpc3RlbmVyKSBHLnRhcmdldDtcbiAgU3RhdGUuc2V0X2xpc3RlbmVyIGtleV9kb3duX2xpc3RlbmVyIGtleV91cF9saXN0ZW5lclxuXG5sZXQgc2V0X3VwX2pveXBhZCAodHlwZSBhKSAobW9kdWxlIEMgOiBDYW1sYm95X2ludGYuUyB3aXRoIHR5cGUgdCA9IGEpICh0IDogYSkgPVxuICBsZXQgdXBfZWwsIGRvd25fZWwsIGxlZnRfZWwsIHJpZ2h0X2VsID1cbiAgICBmaW5kX2VsX2J5X2lkIFwidXBcIiwgZmluZF9lbF9ieV9pZCBcImRvd25cIiwgZmluZF9lbF9ieV9pZCBcImxlZnRcIiwgZmluZF9lbF9ieV9pZCBcInJpZ2h0XCIgaW5cbiAgbGV0IGFfZWwsIGJfZWwgPSBmaW5kX2VsX2J5X2lkIFwiYVwiLCBmaW5kX2VsX2J5X2lkIFwiYlwiIGluXG4gIGxldCBzdGFydF9lbCwgc2VsZWN0X2VsID0gZmluZF9lbF9ieV9pZCBcInN0YXJ0XCIsIGZpbmRfZWxfYnlfaWQgXCJzZWxlY3RcIiBpblxuICAoKiBUT0RPOiB1bmxpc3RlbiB0aGVzZSBsaXN0ZW5lciBvbiByb20gY2hhbmdlICopXG4gIGxldCBwcmVzcyBldiB0IGtleSA9IEV2LnByZXZlbnRfZGVmYXVsdCBldjsgdmliZXJhdGUgMTA7IEMucHJlc3MgdCBrZXkgaW5cbiAgbGV0IHJlbGVhc2UgZXYgdCBrZXkgPSBFdi5wcmV2ZW50X2RlZmF1bHQgZXY7IEMucmVsZWFzZSB0IGtleSBpblxuICBsZXQgbGlzdGVuX29wcyA9IEV2Lmxpc3Rlbl9vcHRzIH5jYXB0dXJlOnRydWUgKCkgaW5cbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoc3RhcnQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHByZXNzIGV2IHQgVXApICAgICAoRWwuYXNfdGFyZ2V0IHVwX2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoc3RhcnQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHByZXNzIGV2IHQgRG93bikgICAoRWwuYXNfdGFyZ2V0IGRvd25fZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hzdGFydCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcHJlc3MgZXYgdCBMZWZ0KSAgIChFbC5hc190YXJnZXQgbGVmdF9lbCk7XG4gIEV2Lmxpc3RlbiBNeV9ldi50b3VjaHN0YXJ0IH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiBwcmVzcyBldiB0IFJpZ2h0KSAgKEVsLmFzX3RhcmdldCByaWdodF9lbCk7XG4gIEV2Lmxpc3RlbiBNeV9ldi50b3VjaHN0YXJ0IH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiBwcmVzcyBldiB0IEEpICAgICAgKEVsLmFzX3RhcmdldCBhX2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoc3RhcnQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHByZXNzIGV2IHQgQikgICAgICAoRWwuYXNfdGFyZ2V0IGJfZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hzdGFydCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcHJlc3MgZXYgdCBTdGFydCkgIChFbC5hc190YXJnZXQgc3RhcnRfZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hzdGFydCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcHJlc3MgZXYgdCBTZWxlY3QpIChFbC5hc190YXJnZXQgc2VsZWN0X2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoZW5kIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiByZWxlYXNlIGV2IHQgVXApICAgICAoRWwuYXNfdGFyZ2V0IHVwX2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoZW5kIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiByZWxlYXNlIGV2IHQgRG93bikgICAoRWwuYXNfdGFyZ2V0IGRvd25fZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hlbmQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHJlbGVhc2UgZXYgdCBMZWZ0KSAgIChFbC5hc190YXJnZXQgbGVmdF9lbCk7XG4gIEV2Lmxpc3RlbiBNeV9ldi50b3VjaGVuZCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcmVsZWFzZSBldiB0IFJpZ2h0KSAgKEVsLmFzX3RhcmdldCByaWdodF9lbCk7XG4gIEV2Lmxpc3RlbiBNeV9ldi50b3VjaGVuZCB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcmVsZWFzZSBldiB0IEEpICAgICAgKEVsLmFzX3RhcmdldCBhX2VsKTtcbiAgRXYubGlzdGVuIE15X2V2LnRvdWNoZW5kIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiByZWxlYXNlIGV2IHQgQikgICAgICAoRWwuYXNfdGFyZ2V0IGJfZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hlbmQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHJlbGVhc2UgZXYgdCBTdGFydCkgIChFbC5hc190YXJnZXQgc3RhcnRfZWwpO1xuICBFdi5saXN0ZW4gTXlfZXYudG91Y2hlbmQgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHJlbGVhc2UgZXYgdCBTZWxlY3QpIChFbC5hc190YXJnZXQgc2VsZWN0X2VsKVxuXG5sZXQgdGhyb3R0bGVkID0gcmVmIHRydWVcblxubGV0IHJ1bl9yb21fYnl0ZXMgY3R4IGltYWdlX2RhdGEgcm9tX2J5dGVzID1cbiAgU3RhdGUuY2xlYXIgKCk7XG4gIGxldCBjYXJ0cmlkZ2UgPSBEZXRlY3RfY2FydHJpZGdlLmYgfnJvbV9ieXRlcyBpblxuICBsZXQgbW9kdWxlIEMgPSBDYW1sYm95Lk1ha2UodmFsIGNhcnRyaWRnZSkgaW5cbiAgbGV0IHQgPSAgQy5jcmVhdGVfd2l0aF9yb20gfnByaW50X3NlcmlhbF9wb3J0OnRydWUgfnJvbV9ieXRlcyBpblxuICBzZXRfdXBfa2V5Ym9hcmQgKG1vZHVsZSBDKSB0O1xuICBzZXRfdXBfam95cGFkIChtb2R1bGUgQykgdDtcbiAgbGV0IGNudCA9IHJlZiAwIGluXG4gIGxldCBzdGFydF90aW1lID0gcmVmIChQZXJmb3JtYW5jZS5ub3dfbXMgRy5wZXJmb3JtYW5jZSkgaW5cbiAgbGV0IHNldF9mcHMgZnBzID1cbiAgICBsZXQgZnBzX3N0ciA9IFByaW50Zi5zcHJpbnRmIFwiJS4xZlwiIGZwcyBpblxuICAgIGxldCBmcHNfZWwgPSBmaW5kX2VsX2J5X2lkIFwiZnBzXCIgaW5cbiAgICBFbC5zZXRfY2hpbGRyZW4gZnBzX2VsIFtFbC50eHQgKEpzdHIudiBmcHNfc3RyKV1cbiAgaW5cbiAgbGV0IHJlYyBtYWluX2xvb3AgKCkgPVxuICAgIGJlZ2luIG1hdGNoIEMucnVuX2luc3RydWN0aW9uIHQgd2l0aFxuICAgICAgfCBJbl9mcmFtZSAtPlxuICAgICAgICBtYWluX2xvb3AgKClcbiAgICAgIHwgRnJhbWVfZW5kZWQgZmIgLT5cbiAgICAgICAgaW5jciBjbnQ7XG4gICAgICAgIGlmICFjbnQgPSA2MCB0aGVuIGJlZ2luXG4gICAgICAgICAgbGV0IGVuZF90aW1lID0gUGVyZm9ybWFuY2Uubm93X21zIEcucGVyZm9ybWFuY2UgaW5cbiAgICAgICAgICBsZXQgc2VjX3Blcl82MF9mcmFtZSA9IChlbmRfdGltZSAtLiAhc3RhcnRfdGltZSkgLy4gMTAwMC4gaW5cbiAgICAgICAgICBsZXQgZnBzID0gNjAuIC8uICBzZWNfcGVyXzYwX2ZyYW1lIGluXG4gICAgICAgICAgc3RhcnRfdGltZSA6PSBlbmRfdGltZTtcbiAgICAgICAgICBzZXRfZnBzIGZwcztcbiAgICAgICAgICBjbnQgOj0gMDtcbiAgICAgICAgZW5kO1xuICAgICAgICBkcmF3X2ZyYW1lYnVmZmVyIGN0eCBpbWFnZV9kYXRhIGZiO1xuICAgICAgICBpZiBub3QgIXRocm90dGxlZCB0aGVuXG4gICAgICAgICAgU3RhdGUucnVuX2lkIDo9IFNvbWUgKEcuc2V0X3RpbWVvdXQgfm1zOjAgbWFpbl9sb29wKVxuICAgICAgICBlbHNlXG4gICAgICAgICAgU3RhdGUucnVuX2lkIDo9IFNvbWUgKEcucmVxdWVzdF9hbmltYXRpb25fZnJhbWUgKGZ1biBfIC0+IG1haW5fbG9vcCAoKSkpXG4gICAgZW5kO1xuICBpblxuICBtYWluX2xvb3AgKClcblxubGV0IHJ1bl9yb21fYmxvYiBjdHggaW1hZ2VfZGF0YSByb21fYmxvYiA9XG4gIGxldCogcmVzdWx0ID0gQmxvYi5hcnJheV9idWZmZXIgcm9tX2Jsb2IgaW5cbiAgbWF0Y2ggcmVzdWx0IHdpdGhcbiAgfCBPayBidWYgLT5cbiAgICBsZXQgcm9tX2J5dGVzID1cbiAgICAgIFRhcnJheS5vZl9idWZmZXIgVWludDggYnVmXG4gICAgICB8PiBUYXJyYXkudG9fYmlnYXJyYXkxXG4gICAgICAoKiBDb252ZXJ0IHVpbnQ4IGJpZ2FycmF5IHRvIGNoYXIgYmlnYXJyYXkgKilcbiAgICAgIHw+IE9iai5tYWdpY1xuICAgIGluXG4gICAgRnV0LnJldHVybiBAQCBydW5fcm9tX2J5dGVzIGN0eCBpbWFnZV9kYXRhIHJvbV9ieXRlc1xuICB8IEVycm9yIGUgLT5cbiAgICBGdXQucmV0dXJuIEBAIENvbnNvbGUuKGxvZyBbSnYuRXJyb3IubWVzc2FnZSBlXSlcblxubGV0IG9uX2xvYWRfcm9tIGN0eCBpbWFnZV9kYXRhIGlucHV0X2VsID1cbiAgbGV0IGZpbGUgPSBFbC5JbnB1dC5maWxlcyBpbnB1dF9lbCB8PiBMaXN0LmhkIGluXG4gIGxldCBibG9iID0gRmlsZS5hc19ibG9iIGZpbGUgaW5cbiAgRnV0LmF3YWl0IChydW5fcm9tX2Jsb2IgY3R4IGltYWdlX2RhdGEgYmxvYikgKGZ1biAoKSAtPiAoKSlcblxubGV0IHJ1bl9zZWxlY3RlZF9yb20gY3R4IGltYWdlX2RhdGEgcm9tX3BhdGggPVxuICBsZXQqIHJlc3VsdCA9IEZldGNoLnVybCAoSnN0ci52IHJvbV9wYXRoKSBpblxuICBtYXRjaCByZXN1bHQgd2l0aFxuICB8IE9rIHJlc3BvbnNlIC0+XG4gICAgbGV0IGJvZHkgPSBGZXRjaC5SZXNwb25zZS5hc19ib2R5IHJlc3BvbnNlIGluXG4gICAgbGV0KiByZXN1bHQgPSBGZXRjaC5Cb2R5LmJsb2IgYm9keSBpblxuICAgIGJlZ2luIG1hdGNoIHJlc3VsdCB3aXRoXG4gICAgICB8IE9rIGJsb2IgLT4gcnVuX3JvbV9ibG9iIGN0eCBpbWFnZV9kYXRhIGJsb2JcbiAgICAgIHwgRXJyb3IgZSAgLT4gRnV0LnJldHVybiBAQCBDb25zb2xlLihsb2cgW0p2LkVycm9yLm1lc3NhZ2UgZV0pXG4gICAgZW5kXG4gIHwgRXJyb3IgZSAgLT4gRnV0LnJldHVybiBAQCBDb25zb2xlLihsb2cgW0p2LkVycm9yLm1lc3NhZ2UgZV0pXG5cbmxldCBzZXRfdXBfcm9tX3NlbGVjdG9yIGN0eCBpbWFnZV9kYXRhIHNlbGVjdG9yX2VsID1cbiAgcm9tX29wdGlvbnNcbiAgfD4gTGlzdC5tYXAgKGZ1biByb21fb3B0aW9uIC0+XG4gICAgICBFbC5vcHRpb25cbiAgICAgICAgfmF0OkF0Llt2YWx1ZSAoSnN0ci52IHJvbV9vcHRpb24ucGF0aCldXG4gICAgICAgIFtFbC50eHQnIHJvbV9vcHRpb24ubmFtZV0pXG4gIHw+IEVsLmFwcGVuZF9jaGlsZHJlbiBzZWxlY3Rvcl9lbDtcbiAgbGV0IG9uX2NoYW5nZSBfID1cbiAgICBsZXQgcm9tX3BhdGggPSBFbC5wcm9wIChFbC5Qcm9wLnZhbHVlKSBzZWxlY3Rvcl9lbCB8PiBKc3RyLnRvX3N0cmluZyBpblxuICAgIEZ1dC5hd2FpdCAocnVuX3NlbGVjdGVkX3JvbSBjdHggaW1hZ2VfZGF0YSByb21fcGF0aCkgKGZ1biAoKSAtPiAoKSlcbiAgaW5cbiAgRXYubGlzdGVuIEV2LmNoYW5nZSBvbl9jaGFuZ2UgKEVsLmFzX3RhcmdldCBzZWxlY3Rvcl9lbClcblxubGV0IG9uX2NoZWNrYm94X2NoYW5nZSBjaGVja2JveF9lbCA9XG4gIGxldCBjaGVja2VkID0gRWwucHJvcCAoRWwuUHJvcC5jaGVja2VkKSBjaGVja2JveF9lbCBpblxuICB0aHJvdHRsZWQgOj0gY2hlY2tlZFxuXG5sZXQgKCkgPVxuICAoKiBTZXQgdXAgY2FudmFzICopXG4gIGxldCBjYW52YXMgPSBmaW5kX2VsX2J5X2lkIFwiY2FudmFzXCIgfD4gQ2FudmFzLm9mX2VsIGluXG4gIGxldCBjdHggPSBDMmQuY3JlYXRlIGNhbnZhcyBpblxuICBDMmQuc2NhbGUgY3R4IH5zeDoxLjUgfnN5OjEuNTtcbiAgbGV0IGltYWdlX2RhdGEgPSBDMmQuY3JlYXRlX2ltYWdlX2RhdGEgY3R4IH53OmdiX3cgfmg6Z2JfaCBpblxuICBsZXQgZmIgPSBBcnJheS5tYWtlX21hdHJpeCBnYl9oIGdiX3cgYExpZ2h0X2dyYXkgaW5cbiAgZHJhd19mcmFtZWJ1ZmZlciBjdHggaW1hZ2VfZGF0YSBmYjtcbiAgKCogU2V0IHVwIHRocm90dGxlIGNoZWNrYm94ICopXG4gIGxldCBjaGVja2JveF9lbCA9IGZpbmRfZWxfYnlfaWQgXCJ0aHJvdHRsZVwiIGluXG4gIEV2Lmxpc3RlbiBFdi5jaGFuZ2UgKGZ1biBfIC0+IG9uX2NoZWNrYm94X2NoYW5nZSBjaGVja2JveF9lbCkgKEVsLmFzX3RhcmdldCBjaGVja2JveF9lbCk7XG4gICgqIFNldCB1cCBsb2FkIHJvbSBidXR0b24gKilcbiAgbGV0IGlucHV0X2VsID0gZmluZF9lbF9ieV9pZCBcImxvYWQtcm9tXCIgaW5cbiAgRXYubGlzdGVuIEV2LmNoYW5nZSAoZnVuIF8gLT4gb25fbG9hZF9yb20gY3R4IGltYWdlX2RhdGEgaW5wdXRfZWwpIChFbC5hc190YXJnZXQgaW5wdXRfZWwpO1xuICAoKiBTZXQgdXAgcm9tIHNlbGVjdG9yICopXG4gIGxldCBzZWxlY3Rvcl9lbCA9IGZpbmRfZWxfYnlfaWQgXCJyb20tc2VsZWN0b3JcIiBpblxuICBzZXRfdXBfcm9tX3NlbGVjdG9yIGN0eCBpbWFnZV9kYXRhIHNlbGVjdG9yX2VsO1xuICAoKiBMb2FkIGluaXRpYWwgcm9tICopXG4gIGxldCByb20gPSBMaXN0LmhkIHJvbV9vcHRpb25zIGluXG4gIGxldCBmdXQgPSBydW5fc2VsZWN0ZWRfcm9tIGN0eCBpbWFnZV9kYXRhIHJvbS5wYXRoIGluXG4gIEZ1dC5hd2FpdCBmdXQgKGZ1biAoKSAtPiAoKSlcbiJdfQ==
