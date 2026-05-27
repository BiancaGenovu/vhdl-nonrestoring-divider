-- Fisier: AddSub.vhd
USE work.sumpack.ALL; 

ENTITY AddSub IS  
	GENERIC(delay: TIME := 5 ns; N: INTEGER:=16); 
	PORT(
	    op1, op2: IN BIT_VECTOR(N-1 DOWNTO 0);
	    cin: IN BIT;
	    cmd: IN BIT; -- 0 adunare, 1 scadere
	    result: OUT BIT_VECTOR(N-1 DOWNTO 0)
	);
END AddSub;

ARCHITECTURE behavior OF AddSub IS
BEGIN
	PROCESS(op1, op2, cin, cmd)
		VARIABLE temp_op2: BIT_VECTOR(n-1 DOWNTO 0);
		VARIABLE temp_cin: BIT;
	BEGIN
		IF cmd ='0' THEN
		    -- ADUNARE: A + B
			temp_op2 := op2;
			temp_cin := cin;
		ELSE
		    -- SCADERE: A + (not B) + 1
			temp_op2 := NOT op2;
			temp_cin := '1'; 
		END IF;
		
		result <= suma(op1, temp_op2, temp_cin) AFTER delay;
		
	END PROCESS;
END behavior;