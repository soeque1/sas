%macro RandBetween(min, max);
	(&min + floor((1+&max-&min)*rand("uniform")));
%mend;

proc fcmp outlib=work.funcs.baseballG;
		function check_ball(num1, num2, num3, ans1, ans2, ans3) $ 50;
		array ans {3} ans1 ans2 ans3;
		array input_num {3} num1 num2 num3;

		/* strike */
		s_cnt=0;

		/* ball   */
		b_cnt=0;

		do i=1 to dim(ans);

			do j=1 to dim(input_num);

				if input_num{i}=ans{j} and i=j then
					s_cnt=s_cnt + 1;
				else if input_num{i}=ans{j} and i <> j then
					b_cnt=b_cnt + 1;
			end;
		end;
		res=put(s_cnt, 1.)||'strikes '|| put(b_cnt, 1.)||'balls';
		return (res);
endsub;

options cmplib=work.funcs;

%MACRO run_baseball();

		data ans;
			ans1=%RandBetween(1, 9);
			ans2=%RandBetween(1, 9);
			ans3=%RandBetween(1, 9);
			array ans {3} ans1 ans2 ans3;

			do while (ans{1}=ans{2});
				ans{2}=%RandBetween(1, 9);
			end;

			do while (ans{1}=ans{3} or ans{2}=ans{3});
				ans{3}=%RandBetween(1, 9);
			end;
		run;

		%LET s_cnt = 0;
		%LET t_cnt = 0;

		/*%DO t_cnt=1 %TO 1;*/
		%DO %WHILE (&s_cnt < 3 and &t_cnt < 10); /* 최대 10번 시도 */

			%let t_cnt = %eval(&t_cnt+1);

			data res;
				
				%window info  color = white

				/* dimensions of window */
				icolumn = 55 irow = 10
				columns = 50 rows = 30 

				#5 @5 'Please Enter Numbers:'
				#5 @26 a 1 attr = underline
				#5 @28 b 1 attr = underline
				#5 @30 c 1 attr = underline;	
				
				%display info;

				set ans;
				t_cnt_p=&t_cnt||'th Trial';
				put t_cnt_p;
				res=check_ball(&a, &b, &c, ans1, ans2, ans3);
				put res;
				call symput('res',trim(left(res)));
			run; 
			
			%let s_cnt = %substr(&res,1,1);

		%END;	

		/* 성공 vs 실패 */
		
		%IF &s_cnt = 3 %THEN %put "성공";
		%ELSE %put "실패";

%MEND;

%run_baseball();
