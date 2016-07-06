*********************************
* RandBetween                   *
* 1~9까지 한자리 숫자 랜덤 생성 *
* @parms min, max 		*
*********************************;
%macro RandBetween(min, max);
	(&min + floor((1+&max-&min)*rand("uniform")));
%mend;

***************************************************************
* check_ball                                                  *
* 입력 숫자와 답 체크하여 스트라이크 및 볼 출력               *
* @parms num1-num3, ans1-ans3 			              *
* TODO                                                        *
***************************************************************;
proc fcmp outlib=work.funcs.baseballG;
		/* TODO 
            : INPUT을 입력숫자, 답 2개의 array or 1개의 data.frame로 처리 */
		function check_ball(num1, num2, num3, ans1, ans2, ans3) $ 50;
		array ans {3} ans1 ans2 ans3;
		array input_num {3} num1 num2 num3;

		/* strike 카운트 */
		s_cnt=0;

		/* ball  카운트 */
		b_cnt=0;

		do i=1 to dim(ans);

			do j=1 to dim(input_num);

				if input_num{i}=ans{j} and i=j then
					s_cnt=s_cnt + 1;
				else if input_num{i}=ans{j} and i <> j then
					b_cnt=b_cnt + 1;
			end;
		end;

		/* TODO 
            : OUTPUT을 strikes, balls 2개의 숫자로 반환 or data.frame으로 반환 */
		res=put(s_cnt, 1.)||'strikes '|| put(b_cnt, 1.)||'balls';
		return (res);
endsub;

/* funcs 메모리상 등록 */
options cmplib=work.funcs;


***************************************************************
* run_baseball                                                *
* EVAL 함수 - 답 생성(ans) 후 스트라이크 & 볼 체크 (res)      *
*                        			              *
* TODO                                                        *
***************************************************************;
%MACRO run_baseball();

        /* 답 생성(3자리) */
        /* TODO 
            : N자리 중복 없는 연속숫자 생성으로 일반화 필요 */
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

		/* 스트라이크 숫자 */
		%LET s_cnt = 0; 

		/* 시도 횟수 */
		%LET t_cnt = 0;

		%DO %WHILE (&s_cnt < 3 and &t_cnt < 10); /* 최대 10번 시도 */

			%let t_cnt = %eval(&t_cnt+1);

			data res;
				
				%window info  color = white
				/* dimensions of window */
				icolumn = 55 irow = 10
				columns = 50 rows = 30 

				#5 @5 'Please Enter Number:'
				#5 @26 a 1 attr = underline
				#5 @28 b 1 attr = underline
				#5 @30 c 1 attr = underline;	
				
				%display info;

				set ans;
				t_cnt_p=&t_cnt||'th Trials';
				put t_cnt_p;
				/* TODO
				    : 입력 변수 n자리 숫자로 일반화 필요
				      (입력 숫자와 답 2개의 array 처리 or data.frame 처리 필요) */
				res=check_ball(&a, &b, &c, ans1, ans2, ans3);
				/*  TODO
				     :a check_ball의 반환값 res(스트라이크 볼 갯수)를 %display에 print 필요 */
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
