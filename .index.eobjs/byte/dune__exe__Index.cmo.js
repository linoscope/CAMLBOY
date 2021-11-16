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
     cst_viberate=caml_string_of_jsbytes("viberate"),
     rom_options=
      [0,
       [0,
        caml_string_of_jsbytes("The Bouncing Ball"),
        caml_string_of_jsbytes("./the-bouncing-ball.gb")],
       [0,
        [0,
         caml_string_of_jsbytes("Retroid"),
         caml_string_of_jsbytes("./retroid.gb")],
        [0,
         [0,
          caml_string_of_jsbytes("Into The Blue"),
          caml_string_of_jsbytes("./into-the-blue.gb")],
         [0,
          [0,
           caml_string_of_jsbytes("Tobu Tobu Girl"),
           caml_string_of_jsbytes("./tobu.gb")],
          [0,
           [0,
            caml_string_of_jsbytes("Wishing Sarah"),
            caml_string_of_jsbytes("./dreaming-sarah.gb")],
           [0,
            [0,
             caml_string_of_jsbytes("Rocket Man Demo"),
             caml_string_of_jsbytes("./rocket-man-demo.gb")],
            [0,
             [0,
              caml_string_of_jsbytes("SHEEP IT UP"),
              caml_string_of_jsbytes("./sheep-it-up.gb")],
             0]]]]]]],
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
     Brr_canvas=global_data.Brr_canvas,
     Stdlib_Option=global_data.Stdlib__Option,
     Stdlib_Array=global_data.Stdlib__Array,
     _b_=[0,[8,[0,0,0],0,[0,2],0],caml_string_of_jsbytes("%.2f")],
     _a_=[0,1],
     gb_w=160,
     gb_h=144;
    function alert(v)
     {var alert=Jv[12].alert;alert(caml_call1(Jv[23],v));return 0}
    function viberate(ms)
     {var
       navigator=Jv[12].navigator,
       match=caml_call2(Jv[13],navigator,cst_viberate);
      if(match){var viberate=match[1];viberate(ms);return 0}
      return 0}
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
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][97],_G_,up_el);
        function _H_(ev){return press(ev,t,0)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][97],_H_,down_el);
        function _I_(ev){return press(ev,t,2)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][97],_I_,left_el);
        function _J_(ev){return press(ev,t,3)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][97],_J_,right_el);
        function _K_(ev){return press(ev,t,7)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][97],_K_,a_el);
        function _L_(ev){return press(ev,t,6)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][97],_L_,b_el);
        function _M_(ev){return press(ev,t,4)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][97],_M_,start_el);
        function _N_(ev){return press(ev,t,5)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][97],_N_,select_el);
        function _O_(ev){return release(ev,t,1)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][99],_O_,up_el);
        function _P_(ev){return release(ev,t,0)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][99],_P_,down_el);
        function _Q_(ev){return release(ev,t,2)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][99],_Q_,left_el);
        function _R_(ev){return release(ev,t,3)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][99],_R_,right_el);
        function _S_(ev){return release(ev,t,7)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][99],_S_,a_el);
        function _T_(ev){return release(ev,t,6)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][99],_T_,b_el);
        function _U_(ev){return release(ev,t,4)}
        caml_call4(Brr[7][20],[0,listen_ops],Brr[7][99],_U_,start_el);
        function _V_(ev){return release(ev,t,5)}
        return caml_call4(Brr[7][20],[0,listen_ops],Brr[7][99],_V_,select_el)}}
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

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLjAsImZpbGUiOiIuaW5kZXguZW9ianMvYnl0ZS9kdW5lX19leGVfX0luZGV4LmNtby5qcyIsInNvdXJjZVJvb3QiOiIiLCJuYW1lcyI6WyJyb21fb3B0aW9ucyIsImdiX3ciLCJnYl9oIiwiYWxlcnQiLCJ2IiwidmliZXJhdGUiLCJtcyIsIm5hdmlnYXRvciIsImZpbmRfZWxfYnlfaWQiLCJpZCIsImRyYXdfZnJhbWVidWZmZXIiLCJjdHgiLCJpbWFnZV9kYXRhIiwiZmIiLCJkIiwieSIsIngiLCJvZmYiLCJydW5faWQiLCJrZXlfZG93bl9saXN0ZW5lciIsImtleV91cF9saXN0ZW5lciIsInNldF9saXN0ZW5lciIsImRvd24iLCJ1cCIsImNsZWFyIiwidGltZXJfaWQiLCJsaXN0ZXIiLCJsaXN0ZXIkMCIsInNldF91cF9rZXlib2FyZCIsIkMiLCJ0IiwiZXYiLCJrZXlfbmFtZSIsInNldF91cF9qb3lwYWQiLCJyaWdodF9lbCIsImxlZnRfZWwiLCJkb3duX2VsIiwidXBfZWwiLCJiX2VsIiwiYV9lbCIsInNlbGVjdF9lbCIsInN0YXJ0X2VsIiwicHJlc3MiLCJrZXkiLCJyZWxlYXNlIiwibGlzdGVuX29wcyIsInRocm90dGxlZCIsInJ1bl9yb21fYnl0ZXMiLCJyb21fYnl0ZXMiLCJjYXJ0cmlkZ2UiLCJjbnQiLCJzdGFydF90aW1lIiwibWFpbl9sb29wIiwiZW5kX3RpbWUiLCJzZWNfcGVyXzYwX2ZyYW1lIiwiZnBzIiwiZnBzX3N0ciIsImZwc19lbCIsInJ1bl9yb21fYmxvYiIsInJvbV9ibG9iIiwicmVzdWx0IiwiYnVmIiwiZSIsIm9uX2xvYWRfcm9tIiwiaW5wdXRfZWwiLCJmaWxlIiwicnVuX3NlbGVjdGVkX3JvbSIsInJvbV9wYXRoIiwicmVzcG9uc2UiLCJibG9iIiwic2V0X3VwX3JvbV9zZWxlY3RvciIsInNlbGVjdG9yX2VsIiwicm9tX29wdGlvbiIsIm9uX2NoYW5nZSIsIm9uX2NoZWNrYm94X2NoYW5nZSIsImNoZWNrYm94X2VsIiwiY2hlY2tlZCIsImNhbnZhcyIsInJvbSIsImZ1dCJdLCJzb3VyY2VzIjpbIi9ob21lL3J1bm5lci93b3JrL0NBTUxCT1kvQ0FNTEJPWS9fYnVpbGQvZGVmYXVsdC9iaW4vd2ViL2luZGV4Lm1sIl0sIm1hcHBpbmdzIjoiOztJOzs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7S0FXSUE7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7Ozs7O0tBSkFDO0tBQ0FDO2FBYUFDLE1BQU1DO01BQ0ksSUFBUkQsbUJBQ00sTUFBcUIsa0JBRnZCQyxJQUVFLFFBQW1DO2FBRTNDQyxTQUFTQztNQUNLOztPQUNWLHdCQURGQztNQUNFLFVBRWEsSUFBWkYsa0JBQXNCLFNBSmxCQyxJQUlrQjtNQURuQixRQUN1RDthQUUvREUsY0FBY0M7TUFBSyx5Q0FBa0Msd0JBQXZDQTtNQUFLLHVDQUEyRDthQUU5RUMsaUJBQWlCQyxJQUFJQyxXQUFXQztNQUMxQixzQ0FEZUQsWUFFdkJHOztNQUNFOztRQUNFOztxQkFGSkEsZUFDRUM7V0FFYyx1QkFBTixpQkFMd0JILEdBRWxDRSxVQUNFQztVQUVjOzthQVlWLEVBYkVDO2FBY0YsRUFkRUE7YUFlRixFQWZFQTthQWdCRixFQWhCRUE7O2FBR0YsRUFIRUE7YUFJRixFQUpFQTthQUtGLEVBTEVBO2FBTUYsRUFORUE7OzthQVFGLEVBUkVBO2FBU0YsRUFURUE7YUFVRixFQVZFQTthQVdGLEVBWEVBOzthQWtCRixFQWxCRUE7YUFtQkYsRUFuQkVBO2FBb0JGLEVBcEJFQTthQXFCRixFQXJCRUE7VUFBSixRQURGRDs7VUFDRSxRQUZKRDs7VUEwQkEsb0NBNUJtQkosSUFBSUMsaUJBNEJvQjtRQUl2Q00sYUFDQUMsd0JBQ0FDO2FBQ0FDLGFBQWFDLEtBQUtDO01BQ3BCLDBCQURlRCxNQUNmLHdCQURvQkMsSUFDcEIsUUFDMEI7YUFDeEJDO01BQ0YsUUFQRU47TUFPRjtRQUdJLElBREtPO1FBQ0wsdUJBREtBO1FBRUwsdUJBRktBO01BRlQsUUFORU47TUFZ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QUFsQ0U7U0FBNkI7cUNBQXlCO01BVGhELGtDQUFVLHdCQURVSztNQUNwQixxQ0FTZ0Q7YUFFNURHLG9CQUFvQjNELElBQUlDLFdBQVcyRDtNQUNyQyxhQUNpQkM7UUFHVjt1Q0FIVUE7U0FFSDs7b0NBQU0sd0JBRkhBO1FBRUgsd0NBQ2lCO01BQUMsbUJBSDdCLGdDQWhORHhFO01Bb04rQixXQUE5QixzQkFOa0N1RTtNQU1KLFNBQzdCRTtRQUNnRDtTQUE5Q047VUFBOEM7WUFBbkMscUNBUm9CSTtRQVFlLG9CQUNjLFFBQUU7UUFBeEQseUJBVFU1RCxJQUFJQyxXQVFwQnVEO1FBQ00saUNBQXlEO01BSHBDLDBDQUM3Qk0sVUFQaUNGLFlBV21CO2FBRXRERyxtQkFBbUJDO01BQ1AsSUFBVkMsUUFBVSxvQ0FET0Q7TUFDUCxlQUFWQztNQUFVLFFBQ007SUFJUDs7O0tBQ0gsbUNBRE5DO0lBRUosNkJBRElsRTtJQURTO0tBR0ksd0NBRmJBLElBdE9GVixLQUNBQztLQXdPTyw4QkF4T1BBLEtBREFEO0lBME9GLGlCQUpJVSxJQUVBQyxXQUNBQztJQUpTLElBT1Q4RCxZQUFjO3dCQUNZLDBCQUQxQkEsWUFDd0Q7SUFBNUQsdUNBRElBO0lBR1csSUFBWFgsU0FBVzt3QkFDZSxtQkFWMUJyRCxJQUVBQyxXQU9Bb0QsU0FDNkQ7SUFBakUsdUNBRElBO0lBR2MsSUFBZE8sWUFBYztJQUNsQixvQkFiSTVELElBRUFDLFdBVUEyRDtJQUFjO0tBR1IsOEJBalBSdkU7S0FrUFEscUJBaEJOVyxJQUVBQyxXQWFBa0U7SUFDTSxvQkFDZSxRQUFFO0lBQTNCLGtCQURJQztJQUNKOzs7T0F2UEU5RTtPQUNBQztPQUdBRjtPQVVBRztPQUlBRTtPQU1BRztPQUVBRTs7T0F1REFrQjtPQWlDQUs7T0EwQkFhO09BRUFDO09BcUNBVztPQWNBSztPQUtBRztPQVlBSTtPQWFBSTtJQXdCRjtVIiwic291cmNlc0NvbnRlbnQiOlsib3BlbiBDYW1sYm95X2xpYlxub3BlbiBCcnJcbm9wZW4gQnJyX2NhbnZhc1xub3BlbiBCcnJfaW9cbm9wZW4gRnV0LlN5bnRheFxuXG5cbmxldCBnYl93ID0gMTYwXG5sZXQgZ2JfaCA9IDE0NFxuXG50eXBlIHJvbV9vcHRpb24gPSB7bmFtZSA6IHN0cmluZzsgcGF0aCA6IHN0cmluZ31cbmxldCByb21fb3B0aW9ucyA9IFtcbiAge25hbWUgPSBcIlRoZSBCb3VuY2luZyBCYWxsXCIgOyBwYXRoID0gXCIuL3RoZS1ib3VuY2luZy1iYWxsLmdiXCJ9O1xuICB7bmFtZSA9IFwiUmV0cm9pZFwiICAgICAgICAgICA7IHBhdGggPSBcIi4vcmV0cm9pZC5nYlwifTtcbiAge25hbWUgPSBcIkludG8gVGhlIEJsdWVcIiAgICAgOyBwYXRoID0gXCIuL2ludG8tdGhlLWJsdWUuZ2JcIn07XG4gIHtuYW1lID0gXCJUb2J1IFRvYnUgR2lybFwiICAgIDsgcGF0aCA9IFwiLi90b2J1LmdiXCJ9O1xuICB7bmFtZSA9IFwiV2lzaGluZyBTYXJhaFwiICAgIDsgcGF0aCA9IFwiLi9kcmVhbWluZy1zYXJhaC5nYlwifTtcbiAge25hbWUgPSBcIlJvY2tldCBNYW4gRGVtb1wiICAgOyBwYXRoID0gXCIuL3JvY2tldC1tYW4tZGVtby5nYlwifTtcbiAge25hbWUgPSBcIlNIRUVQIElUIFVQXCIgICAgICAgOyBwYXRoID0gXCIuL3NoZWVwLWl0LXVwLmdiXCJ9O1xuXVxuXG5sZXQgYWxlcnQgdiA9XG4gIGxldCBhbGVydCA9IEp2LmdldCBKdi5nbG9iYWwgXCJhbGVydFwiIGluXG4gIGlnbm9yZSBAQCBKdi5hcHBseSBhbGVydCBKdi5bfCBvZl9zdHJpbmcgdiB8XVxuXG5sZXQgdmliZXJhdGUgbXMgPVxuICBsZXQgbmF2aWdhdG9yID0gSnYuZ2V0IEp2Lmdsb2JhbCBcIm5hdmlnYXRvclwiIGluXG4gIG1hdGNoIEp2LmZpbmQgbmF2aWdhdG9yIFwidmliZXJhdGVcIiB3aXRoXG4gIHwgTm9uZSAtPiAoKVxuICB8IFNvbWUgdmliZXJhdGUgLT4gaWdub3JlIEBAIEp2LmFwcGx5IHZpYmVyYXRlIEp2Llt8IG9mX2ludCBtcyB8XVxuXG5sZXQgZmluZF9lbF9ieV9pZCBpZCA9IERvY3VtZW50LmZpbmRfZWxfYnlfaWQgRy5kb2N1bWVudCAoSnN0ci52IGlkKSB8PiBPcHRpb24uZ2V0XG5cbmxldCBkcmF3X2ZyYW1lYnVmZmVyIGN0eCBpbWFnZV9kYXRhIGZiID1cbiAgbGV0IGQgPSBDMmQuSW1hZ2VfZGF0YS5kYXRhIGltYWdlX2RhdGEgaW5cbiAgZm9yIHkgPSAwIHRvIGdiX2ggLSAxIGRvXG4gICAgZm9yIHggPSAwIHRvIGdiX3cgLSAxIGRvXG4gICAgICBsZXQgb2ZmID0gNCAqICh5ICogZ2JfdyArIHgpIGluXG4gICAgICBtYXRjaCBmYi4oeSkuKHgpIHdpdGhcbiAgICAgIHwgYFdoaXRlIC0+XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICAgICkgMHhFNTtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAxKSAweEZCO1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDIpIDB4RjQ7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMykgMHhGRjtcbiAgICAgIHwgYExpZ2h0X2dyYXkgLT5cbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgICAgKSAweDk3O1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDEpIDB4QUU7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMikgMHhCODtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAzKSAweEZGO1xuICAgICAgfCBgRGFya19ncmF5IC0+XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICAgICkgMHg2MTtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAxKSAweDY4O1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDIpIDB4N0Q7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMykgMHhGRjtcbiAgICAgIHwgYEJsYWNrIC0+XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICAgICkgMHgyMjtcbiAgICAgICAgVGFycmF5LnNldCBkIChvZmYgKyAxKSAweDFFO1xuICAgICAgICBUYXJyYXkuc2V0IGQgKG9mZiArIDIpIDB4MzE7XG4gICAgICAgIFRhcnJheS5zZXQgZCAob2ZmICsgMykgMHhGRjtcbiAgICBkb25lXG4gIGRvbmU7XG4gIEMyZC5wdXRfaW1hZ2VfZGF0YSBjdHggaW1hZ2VfZGF0YSB+eDowIH55OjBcblxuKCoqIE1hbmFnZXMgc3RhdGUgdGhhdCBuZWVkIHRvIGJlIHJlc2V0IHdoZW4gbG9hZGluZyBhIG5ldyByb20gKilcbm1vZHVsZSBTdGF0ZSA9IHN0cnVjdFxuICBsZXQgcnVuX2lkID0gcmVmIE5vbmVcbiAgbGV0IGtleV9kb3duX2xpc3RlbmVyID0gcmVmIE5vbmVcbiAgbGV0IGtleV91cF9saXN0ZW5lciA9IHJlZiBOb25lXG4gIGxldCBzZXRfbGlzdGVuZXIgZG93biB1cCA9XG4gICAga2V5X2Rvd25fbGlzdGVuZXIgOj0gU29tZSBkb3duO1xuICAgIGtleV91cF9saXN0ZW5lciA6PSBTb21lIHVwXG4gIGxldCBjbGVhciAoKSA9XG4gICAgYmVnaW4gbWF0Y2ggIXJ1bl9pZCB3aXRoXG4gICAgICB8IE5vbmUgLT4gKClcbiAgICAgIHwgU29tZSB0aW1lcl9pZCAtPlxuICAgICAgICBHLnN0b3BfdGltZXIgdGltZXJfaWQ7XG4gICAgICAgIEcuY2FuY2VsX2FuaW1hdGlvbl9mcmFtZSB0aW1lcl9pZDtcbiAgICBlbmQ7XG4gICAgYmVnaW4gbWF0Y2ggIWtleV9kb3duX2xpc3RlbmVyIHdpdGhcbiAgICAgIHwgTm9uZSAtPiAoKVxuICAgICAgfCBTb21lIGxpc3RlciAtPiBFdi51bmxpc3RlbiBFdi5rZXlkb3duIGxpc3RlciBHLnRhcmdldFxuICAgIGVuZDtcbiAgICBiZWdpbiBtYXRjaCAha2V5X3VwX2xpc3RlbmVyIHdpdGhcbiAgICAgIHwgTm9uZSAtPiAoKVxuICAgICAgfCBTb21lIGxpc3RlciAtPiBFdi51bmxpc3RlbiBFdi5rZXl1cCBsaXN0ZXIgRy50YXJnZXRcbiAgICBlbmRcbmVuZFxuXG5sZXQgc2V0X3VwX2tleWJvYXJkICh0eXBlIGEpIChtb2R1bGUgQyA6IENhbWxib3lfaW50Zi5TIHdpdGggdHlwZSB0ID0gYSkgKHQgOiBhKSA9XG4gIGxldCBrZXlfZG93bl9saXN0ZW5lciBldiA9XG4gICAgbGV0IGtleV9ldiA9IEV2LmFzX3R5cGUgZXYgaW5cbiAgICBsZXQga2V5X25hbWUgPSBrZXlfZXYgfD4gRXYuS2V5Ym9hcmQua2V5IHw+IEpzdHIudG9fc3RyaW5nIGluXG4gICAgbWF0Y2gga2V5X25hbWUgd2l0aFxuICAgIHwgXCJFbnRlclwiIC0+IEMucHJlc3MgdCBTdGFydFxuICAgIHwgXCJTaGlmdFwiIC0+IEMucHJlc3MgdCBTZWxlY3RcbiAgICB8IFwialwiICAgICAtPiBDLnByZXNzIHQgQlxuICAgIHwgXCJrXCIgICAgIC0+IEMucHJlc3MgdCBBXG4gICAgfCBcIndcIiAgICAgLT4gQy5wcmVzcyB0IFVwXG4gICAgfCBcImFcIiAgICAgLT4gQy5wcmVzcyB0IExlZnRcbiAgICB8IFwic1wiICAgICAtPiBDLnByZXNzIHQgRG93blxuICAgIHwgXCJkXCIgICAgIC0+IEMucHJlc3MgdCBSaWdodFxuICAgIHwgXyAgICAgICAtPiAoKVxuICBpblxuICBsZXQga2V5X3VwX2xpc3RlbmVyIGV2ID1cbiAgICBsZXQga2V5X2V2ID0gRXYuYXNfdHlwZSBldiBpblxuICAgIGxldCBrZXlfbmFtZSA9IGtleV9ldiB8PiBFdi5LZXlib2FyZC5rZXkgfD4gSnN0ci50b19zdHJpbmcgaW5cbiAgICBtYXRjaCBrZXlfbmFtZSB3aXRoXG4gICAgfCBcIkVudGVyXCIgLT4gQy5yZWxlYXNlIHQgU3RhcnRcbiAgICB8IFwiU2hpZnRcIiAtPiBDLnJlbGVhc2UgdCBTZWxlY3RcbiAgICB8IFwialwiICAgICAtPiBDLnJlbGVhc2UgdCBCXG4gICAgfCBcImtcIiAgICAgLT4gQy5yZWxlYXNlIHQgQVxuICAgIHwgXCJ3XCIgICAgIC0+IEMucmVsZWFzZSB0IFVwXG4gICAgfCBcImFcIiAgICAgLT4gQy5yZWxlYXNlIHQgTGVmdFxuICAgIHwgXCJzXCIgICAgIC0+IEMucmVsZWFzZSB0IERvd25cbiAgICB8IFwiZFwiICAgICAtPiBDLnJlbGVhc2UgdCBSaWdodFxuICAgIHwgXyAgICAgICAtPiAoKVxuICBpblxuICBFdi5saXN0ZW4gRXYua2V5ZG93biAoa2V5X2Rvd25fbGlzdGVuZXIpIEcudGFyZ2V0O1xuICBFdi5saXN0ZW4gRXYua2V5dXAgKGtleV91cF9saXN0ZW5lcikgRy50YXJnZXQ7XG4gIFN0YXRlLnNldF9saXN0ZW5lciBrZXlfZG93bl9saXN0ZW5lciBrZXlfdXBfbGlzdGVuZXJcblxubGV0IHNldF91cF9qb3lwYWQgKHR5cGUgYSkgKG1vZHVsZSBDIDogQ2FtbGJveV9pbnRmLlMgd2l0aCB0eXBlIHQgPSBhKSAodCA6IGEpID1cbiAgbGV0IHVwX2VsLCBkb3duX2VsLCBsZWZ0X2VsLCByaWdodF9lbCA9XG4gICAgZmluZF9lbF9ieV9pZCBcInVwXCIsIGZpbmRfZWxfYnlfaWQgXCJkb3duXCIsIGZpbmRfZWxfYnlfaWQgXCJsZWZ0XCIsIGZpbmRfZWxfYnlfaWQgXCJyaWdodFwiIGluXG4gIGxldCBhX2VsLCBiX2VsID0gZmluZF9lbF9ieV9pZCBcImFcIiwgZmluZF9lbF9ieV9pZCBcImJcIiBpblxuICBsZXQgc3RhcnRfZWwsIHNlbGVjdF9lbCA9IGZpbmRfZWxfYnlfaWQgXCJzdGFydFwiLCBmaW5kX2VsX2J5X2lkIFwic2VsZWN0XCIgaW5cbiAgKCogVE9ETzogdW5saXN0ZW4gdGhlc2UgbGlzdGVuZXIgd2hlbiByb20gY2hhbmdlICopXG4gIGxldCBwcmVzcyBldiB0IGtleSA9IEV2LnByZXZlbnRfZGVmYXVsdCBldjsgdmliZXJhdGUgMTA7IEMucHJlc3MgdCBrZXkgaW5cbiAgbGV0IHJlbGVhc2UgZXYgdCBrZXkgPSBFdi5wcmV2ZW50X2RlZmF1bHQgZXY7IEMucmVsZWFzZSB0IGtleSBpblxuICBsZXQgbGlzdGVuX29wcyA9IEV2Lmxpc3Rlbl9vcHRzIH5jYXB0dXJlOnRydWUgKCkgaW5cbiAgRXYubGlzdGVuIEV2LnBvaW50ZXJkb3duIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiBwcmVzcyBldiB0IFVwKSAgICAgKEVsLmFzX3RhcmdldCB1cF9lbCk7XG4gIEV2Lmxpc3RlbiBFdi5wb2ludGVyZG93biB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcHJlc3MgZXYgdCBEb3duKSAgIChFbC5hc190YXJnZXQgZG93bl9lbCk7XG4gIEV2Lmxpc3RlbiBFdi5wb2ludGVyZG93biB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcHJlc3MgZXYgdCBMZWZ0KSAgIChFbC5hc190YXJnZXQgbGVmdF9lbCk7XG4gIEV2Lmxpc3RlbiBFdi5wb2ludGVyZG93biB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcHJlc3MgZXYgdCBSaWdodCkgIChFbC5hc190YXJnZXQgcmlnaHRfZWwpO1xuICBFdi5saXN0ZW4gRXYucG9pbnRlcmRvd24gfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHByZXNzIGV2IHQgQSkgICAgICAoRWwuYXNfdGFyZ2V0IGFfZWwpO1xuICBFdi5saXN0ZW4gRXYucG9pbnRlcmRvd24gfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHByZXNzIGV2IHQgQikgICAgICAoRWwuYXNfdGFyZ2V0IGJfZWwpO1xuICBFdi5saXN0ZW4gRXYucG9pbnRlcmRvd24gfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHByZXNzIGV2IHQgU3RhcnQpICAoRWwuYXNfdGFyZ2V0IHN0YXJ0X2VsKTtcbiAgRXYubGlzdGVuIEV2LnBvaW50ZXJkb3duIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiBwcmVzcyBldiB0IFNlbGVjdCkgKEVsLmFzX3RhcmdldCBzZWxlY3RfZWwpO1xuICBFdi5saXN0ZW4gRXYucG9pbnRlcmxlYXZlIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiByZWxlYXNlIGV2IHQgVXApICAgICAoRWwuYXNfdGFyZ2V0IHVwX2VsKTtcbiAgRXYubGlzdGVuIEV2LnBvaW50ZXJsZWF2ZSB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcmVsZWFzZSBldiB0IERvd24pICAgKEVsLmFzX3RhcmdldCBkb3duX2VsKTtcbiAgRXYubGlzdGVuIEV2LnBvaW50ZXJsZWF2ZSB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcmVsZWFzZSBldiB0IExlZnQpICAgKEVsLmFzX3RhcmdldCBsZWZ0X2VsKTtcbiAgRXYubGlzdGVuIEV2LnBvaW50ZXJsZWF2ZSB+b3B0czpsaXN0ZW5fb3BzIChmdW4gZXYgLT4gcmVsZWFzZSBldiB0IFJpZ2h0KSAgKEVsLmFzX3RhcmdldCByaWdodF9lbCk7XG4gIEV2Lmxpc3RlbiBFdi5wb2ludGVybGVhdmUgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHJlbGVhc2UgZXYgdCBBKSAgICAgIChFbC5hc190YXJnZXQgYV9lbCk7XG4gIEV2Lmxpc3RlbiBFdi5wb2ludGVybGVhdmUgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHJlbGVhc2UgZXYgdCBCKSAgICAgIChFbC5hc190YXJnZXQgYl9lbCk7XG4gIEV2Lmxpc3RlbiBFdi5wb2ludGVybGVhdmUgfm9wdHM6bGlzdGVuX29wcyAoZnVuIGV2IC0+IHJlbGVhc2UgZXYgdCBTdGFydCkgIChFbC5hc190YXJnZXQgc3RhcnRfZWwpO1xuICBFdi5saXN0ZW4gRXYucG9pbnRlcmxlYXZlIH5vcHRzOmxpc3Rlbl9vcHMgKGZ1biBldiAtPiByZWxlYXNlIGV2IHQgU2VsZWN0KSAoRWwuYXNfdGFyZ2V0IHNlbGVjdF9lbClcblxubGV0IHRocm90dGxlZCA9IHJlZiB0cnVlXG5cbmxldCBydW5fcm9tX2J5dGVzIGN0eCBpbWFnZV9kYXRhIHJvbV9ieXRlcyA9XG4gIFN0YXRlLmNsZWFyICgpO1xuICBsZXQgY2FydHJpZGdlID0gRGV0ZWN0X2NhcnRyaWRnZS5mIH5yb21fYnl0ZXMgaW5cbiAgbGV0IG1vZHVsZSBDID0gQ2FtbGJveS5NYWtlKHZhbCBjYXJ0cmlkZ2UpIGluXG4gIGxldCB0ID0gIEMuY3JlYXRlX3dpdGhfcm9tIH5wcmludF9zZXJpYWxfcG9ydDp0cnVlIH5yb21fYnl0ZXMgaW5cbiAgc2V0X3VwX2tleWJvYXJkIChtb2R1bGUgQykgdDtcbiAgc2V0X3VwX2pveXBhZCAobW9kdWxlIEMpIHQ7XG4gIGxldCBjbnQgPSByZWYgMCBpblxuICBsZXQgc3RhcnRfdGltZSA9IHJlZiAoUGVyZm9ybWFuY2Uubm93X21zIEcucGVyZm9ybWFuY2UpIGluXG4gIGxldCBzZXRfZnBzIGZwcyA9XG4gICAgbGV0IGZwc19zdHIgPSBQcmludGYuc3ByaW50ZiBcIiUuMmZcIiBmcHMgaW5cbiAgICBsZXQgZnBzX2VsID0gZmluZF9lbF9ieV9pZCBcImZwc1wiIGluXG4gICAgRWwuc2V0X2NoaWxkcmVuIGZwc19lbCBbRWwudHh0IChKc3RyLnYgZnBzX3N0cildXG4gIGluXG4gIGxldCByZWMgbWFpbl9sb29wICgpID1cbiAgICBiZWdpbiBtYXRjaCBDLnJ1bl9pbnN0cnVjdGlvbiB0IHdpdGhcbiAgICAgIHwgSW5fZnJhbWUgLT5cbiAgICAgICAgbWFpbl9sb29wICgpXG4gICAgICB8IEZyYW1lX2VuZGVkIGZiIC0+XG4gICAgICAgIGluY3IgY250O1xuICAgICAgICBpZiAhY250ID0gNjAgdGhlbiBiZWdpblxuICAgICAgICAgIGxldCBlbmRfdGltZSA9IFBlcmZvcm1hbmNlLm5vd19tcyBHLnBlcmZvcm1hbmNlIGluXG4gICAgICAgICAgbGV0IHNlY19wZXJfNjBfZnJhbWUgPSAoZW5kX3RpbWUgLS4gIXN0YXJ0X3RpbWUpIC8uIDEwMDAuIGluXG4gICAgICAgICAgbGV0IGZwcyA9IDYwLiAvLiAgc2VjX3Blcl82MF9mcmFtZSBpblxuICAgICAgICAgIHN0YXJ0X3RpbWUgOj0gZW5kX3RpbWU7XG4gICAgICAgICAgc2V0X2ZwcyBmcHM7XG4gICAgICAgICAgY250IDo9IDA7XG4gICAgICAgIGVuZDtcbiAgICAgICAgZHJhd19mcmFtZWJ1ZmZlciBjdHggaW1hZ2VfZGF0YSBmYjtcbiAgICAgICAgaWYgbm90ICF0aHJvdHRsZWQgdGhlblxuICAgICAgICAgIFN0YXRlLnJ1bl9pZCA6PSBTb21lIChHLnNldF90aW1lb3V0IH5tczowIG1haW5fbG9vcClcbiAgICAgICAgZWxzZVxuICAgICAgICAgIFN0YXRlLnJ1bl9pZCA6PSBTb21lIChHLnJlcXVlc3RfYW5pbWF0aW9uX2ZyYW1lIChmdW4gXyAtPiBtYWluX2xvb3AgKCkpKVxuICAgIGVuZDtcbiAgaW5cbiAgbWFpbl9sb29wICgpXG5cbmxldCBydW5fcm9tX2Jsb2IgY3R4IGltYWdlX2RhdGEgcm9tX2Jsb2IgPVxuICBsZXQqIHJlc3VsdCA9IEJsb2IuYXJyYXlfYnVmZmVyIHJvbV9ibG9iIGluXG4gIG1hdGNoIHJlc3VsdCB3aXRoXG4gIHwgT2sgYnVmIC0+XG4gICAgbGV0IHJvbV9ieXRlcyA9XG4gICAgICBUYXJyYXkub2ZfYnVmZmVyIFVpbnQ4IGJ1ZlxuICAgICAgfD4gVGFycmF5LnRvX2JpZ2FycmF5MVxuICAgICAgKCogQ29udmVydCB1aW50OCBiaWdhcnJheSB0byBjaGFyIGJpZ2FycmF5ICopXG4gICAgICB8PiBPYmoubWFnaWNcbiAgICBpblxuICAgIEZ1dC5yZXR1cm4gQEAgcnVuX3JvbV9ieXRlcyBjdHggaW1hZ2VfZGF0YSByb21fYnl0ZXNcbiAgfCBFcnJvciBlIC0+XG4gICAgRnV0LnJldHVybiBAQCBDb25zb2xlLihsb2cgW0p2LkVycm9yLm1lc3NhZ2UgZV0pXG5cbmxldCBvbl9sb2FkX3JvbSBjdHggaW1hZ2VfZGF0YSBpbnB1dF9lbCA9XG4gIGxldCBmaWxlID0gRWwuSW5wdXQuZmlsZXMgaW5wdXRfZWwgfD4gTGlzdC5oZCBpblxuICBsZXQgYmxvYiA9IEZpbGUuYXNfYmxvYiBmaWxlIGluXG4gIEZ1dC5hd2FpdCAocnVuX3JvbV9ibG9iIGN0eCBpbWFnZV9kYXRhIGJsb2IpIChmdW4gKCkgLT4gKCkpXG5cbmxldCBydW5fc2VsZWN0ZWRfcm9tIGN0eCBpbWFnZV9kYXRhIHJvbV9wYXRoID1cbiAgbGV0KiByZXN1bHQgPSBGZXRjaC51cmwgKEpzdHIudiByb21fcGF0aCkgaW5cbiAgbWF0Y2ggcmVzdWx0IHdpdGhcbiAgfCBPayByZXNwb25zZSAtPlxuICAgIGxldCBib2R5ID0gRmV0Y2guUmVzcG9uc2UuYXNfYm9keSByZXNwb25zZSBpblxuICAgIGxldCogcmVzdWx0ID0gRmV0Y2guQm9keS5ibG9iIGJvZHkgaW5cbiAgICBiZWdpbiBtYXRjaCByZXN1bHQgd2l0aFxuICAgICAgfCBPayBibG9iIC0+IHJ1bl9yb21fYmxvYiBjdHggaW1hZ2VfZGF0YSBibG9iXG4gICAgICB8IEVycm9yIGUgIC0+IEZ1dC5yZXR1cm4gQEAgQ29uc29sZS4obG9nIFtKdi5FcnJvci5tZXNzYWdlIGVdKVxuICAgIGVuZFxuICB8IEVycm9yIGUgIC0+IEZ1dC5yZXR1cm4gQEAgQ29uc29sZS4obG9nIFtKdi5FcnJvci5tZXNzYWdlIGVdKVxuXG5sZXQgc2V0X3VwX3JvbV9zZWxlY3RvciBjdHggaW1hZ2VfZGF0YSBzZWxlY3Rvcl9lbCA9XG4gIHJvbV9vcHRpb25zXG4gIHw+IExpc3QubWFwIChmdW4gcm9tX29wdGlvbiAtPlxuICAgICAgRWwub3B0aW9uXG4gICAgICAgIH5hdDpBdC5bdmFsdWUgKEpzdHIudiByb21fb3B0aW9uLnBhdGgpXVxuICAgICAgICBbRWwudHh0JyByb21fb3B0aW9uLm5hbWVdKVxuICB8PiBFbC5hcHBlbmRfY2hpbGRyZW4gc2VsZWN0b3JfZWw7XG4gIGxldCBvbl9jaGFuZ2UgXyA9XG4gICAgbGV0IHJvbV9wYXRoID0gRWwucHJvcCAoRWwuUHJvcC52YWx1ZSkgc2VsZWN0b3JfZWwgfD4gSnN0ci50b19zdHJpbmcgaW5cbiAgICBGdXQuYXdhaXQgKHJ1bl9zZWxlY3RlZF9yb20gY3R4IGltYWdlX2RhdGEgcm9tX3BhdGgpIChmdW4gKCkgLT4gKCkpXG4gIGluXG4gIEV2Lmxpc3RlbiBFdi5jaGFuZ2Ugb25fY2hhbmdlIChFbC5hc190YXJnZXQgc2VsZWN0b3JfZWwpXG5cbmxldCBvbl9jaGVja2JveF9jaGFuZ2UgY2hlY2tib3hfZWwgPVxuICBsZXQgY2hlY2tlZCA9IEVsLnByb3AgKEVsLlByb3AuY2hlY2tlZCkgY2hlY2tib3hfZWwgaW5cbiAgdGhyb3R0bGVkIDo9IGNoZWNrZWRcblxubGV0ICgpID1cbiAgKCogU2V0IHVwIGNhbnZhcyAqKVxuICBsZXQgY2FudmFzID0gZmluZF9lbF9ieV9pZCBcImNhbnZhc1wiIHw+IENhbnZhcy5vZl9lbCBpblxuICBsZXQgY3R4ID0gQzJkLmNyZWF0ZSBjYW52YXMgaW5cbiAgQzJkLnNjYWxlIGN0eCB+c3g6MS41IH5zeToxLjU7XG4gIGxldCBpbWFnZV9kYXRhID0gQzJkLmNyZWF0ZV9pbWFnZV9kYXRhIGN0eCB+dzpnYl93IH5oOmdiX2ggaW5cbiAgbGV0IGZiID0gQXJyYXkubWFrZV9tYXRyaXggZ2JfaCBnYl93IGBMaWdodF9ncmF5IGluXG4gIGRyYXdfZnJhbWVidWZmZXIgY3R4IGltYWdlX2RhdGEgZmI7XG4gICgqIFNldCB1cCB0aHJvdHRsZSBjaGVja2JveCAqKVxuICBsZXQgY2hlY2tib3hfZWwgPSBmaW5kX2VsX2J5X2lkIFwidGhyb3R0bGVcIiBpblxuICBFdi5saXN0ZW4gRXYuY2hhbmdlIChmdW4gXyAtPiBvbl9jaGVja2JveF9jaGFuZ2UgY2hlY2tib3hfZWwpIChFbC5hc190YXJnZXQgY2hlY2tib3hfZWwpO1xuICAoKiBTZXQgdXAgbG9hZCByb20gYnV0dG9uICopXG4gIGxldCBpbnB1dF9lbCA9IGZpbmRfZWxfYnlfaWQgXCJsb2FkLXJvbVwiIGluXG4gIEV2Lmxpc3RlbiBFdi5jaGFuZ2UgKGZ1biBfIC0+IG9uX2xvYWRfcm9tIGN0eCBpbWFnZV9kYXRhIGlucHV0X2VsKSAoRWwuYXNfdGFyZ2V0IGlucHV0X2VsKTtcbiAgKCogU2V0IHVwIHJvbSBzZWxlY3RvciAqKVxuICBsZXQgc2VsZWN0b3JfZWwgPSBmaW5kX2VsX2J5X2lkIFwicm9tLXNlbGVjdG9yXCIgaW5cbiAgc2V0X3VwX3JvbV9zZWxlY3RvciBjdHggaW1hZ2VfZGF0YSBzZWxlY3Rvcl9lbDtcbiAgKCogTG9hZCBpbml0aWFsIHJvbSAqKVxuICBsZXQgcm9tID0gTGlzdC5oZCByb21fb3B0aW9ucyBpblxuICBsZXQgZnV0ID0gcnVuX3NlbGVjdGVkX3JvbSBjdHggaW1hZ2VfZGF0YSByb20ucGF0aCBpblxuICBGdXQuYXdhaXQgZnV0IChmdW4gKCkgLT4gKCkpXG4iXX0=
