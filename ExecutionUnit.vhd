ENTITY ExecutionUnit IS
    GENERIC( delay: TIME := 10 ns);
        PORT(
            clock, reset: IN BIT;
            deimpartit: IN BIT_VECTOR(15 DOWNTO 0);
            impartitor: IN BIT_VECTOR(15 DOWNTO 0);
            load_init: IN BIT; -- faza de inceput
            shift_en: IN BIT; -- pot face shift
            alu_load: IN BIT; -- pe 1 salvez, pe 0 shiftez
            alu_cmd: IN BIT; -- fac adunare sau scadere
            q_bit_set: IN BIT; -- pe cat pun ultimul bit din Q
            A_semn: OUT BIT;
            count: OUT BIT;
            cat: OUT BIT_VECTOR(15 DOWNTO 0);
            rest: OUT BIT_VECTOR(16 DOWNTO 0)
        );
END ExecutionUnit;

ARCHITECTURE structural OF ExecutionUnit IS

    COMPONENT PIPO IS
        GENERIC( delay: TIME := 10 ns;
                 N: INTEGER := 16);
        PORT(
            clock, reset, load: IN BIT;  
            intrare: IN BIT_VECTOR(N-1 DOWNTO 0);
            iesire: OUT BIT_VECTOR(N-1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT SHIFT_REG IS
        GENERIC( delay: TIME := 10 ns;
                 N: INTEGER := 16);
        PORT(
            clock, reset: IN BIT;
            load: IN BIT;
            shift_en: IN BIT;
            intrare_biti: IN BIT_VECTOR(N-1 DOWNTO 0);
            directie: IN BIT;
            d_in: IN BIT;
            iesire_biti: OUT BIT_VECTOR(N-1 DOWNTO 0);
            d_out: OUT BIT
        );
    END COMPONENT;

    COMPONENT numarator IS
        GENERIC( delay: TIME := 10 ns;
                 MAX_VAL: INTEGER := 10);
        PORT(
            clock, reset: IN BIT;
            load: IN BIT;
            intrare_paralela: IN INTEGER;
            directie: IN BIT;
            enable: IN BIT;
            iesire: OUT INTEGER;
            ovr: OUT BIT
        );
    END COMPONENT;

    COMPONENT AddSub IS
        GENERIC(delay: TIME := 5 ns; N: INTEGER:=17); 
        PORT(
            op1, op2: IN BIT_VECTOR(N-1 DOWNTO 0);
            cin: IN BIT;
            cmd: IN BIT;
            result: OUT BIT_VECTOR(N-1 DOWNTO 0)
        );
    END COMPONENT;

    -- Semnale interne

    -- fire care ies din SHIFT_REG
    SIGNAL A_reg : BIT_VECTOR(16 DOWNTO 0);
    SIGNAL Q_reg : BIT_VECTOR(15 DOWNTO 0);

   
    SIGNAL A_load_data : BIT_VECTOR(16 DOWNTO 0);
    SIGNAL Q_load_data : BIT_VECTOR(15 DOWNTO 0);
    SIGNAL A_load_s    : BIT;
    SIGNAL Q_load_s    : BIT;

    
    SIGNAL M_ext      : BIT_VECTOR(16 DOWNTO 0); -- il extindem M pt a fi de dimensiunea lui A, alrfel nu merge AddSub
    SIGNAL M_reg      : BIT_VECTOR(16 DOWNTO 0); -- fir ce iese din PIPO

    -- bitul care iese din Q si intra in A
    SIGNAL Q_to_A     : BIT;

    SIGNAL A_alu_res  : BIT_VECTOR(16 DOWNTO 0); -- A cand iese din AddSub

    
    SIGNAL cnt_val    : INTEGER; -- la cat a ajuns numaratorul
    SIGNAL cnt_done   : BIT; -- cand e gata numararea

BEGIN

 
    M_ext <= '0' & impartitor;  -- il extindem pe M la 17 biti ca sa fie egal cu A(altfel nu merge AddSub)

    Reg_M: PIPO
        GENERIC MAP(delay => 10 ns, N => 17)
        PORT MAP(
            clock  => clock,
            reset  => reset,
            load   => load_init, -- avem nevoie de load pt a putea incarca M o sg data, M nu se modifica pe parcurs
            intrare => M_ext,
            iesire  => M_reg
        );

    Unit_Arith: AddSub
        GENERIC MAP(delay => 5 ns, N => 17)
        PORT MAP(
            op1    => A_reg,
            op2    => M_reg,
            cin    => '0',
            cmd    => alu_cmd,   -- 0 = adunare, 1 = scadere
            result => A_alu_res
        );

 
    A_load_data <= (others => '0') WHEN load_init = '1'
                   ELSE A_alu_res; -- Daca suntem la inceput A se pune pe 0, dupa aceea A ia rezultatul care iese din AddSub

    A_load_s <= load_init OR alu_load; -- faci load fie la inceput, fie dupa adunare

    Reg_A: SHIFT_REG
        GENERIC MAP(delay => 10 ns, N => 17)
        PORT MAP(
            clock        => clock,
            reset        => reset,
            load         => A_load_s,
            shift_en     => shift_en,
            intrare_biti => A_load_data,
            directie     => '1',       -- shift stanga
            d_in         => Q_to_A,   
            iesire_biti  => A_reg, 
            d_out        => OPEN -- nu ne intereseaza ce iese din A
        );

    Q_load_s <= load_init OR q_bit_set; -- 1 fie la inceput, fie cand trb pus ultimul bit pe 1

    Q_load_data <= deimpartit WHEN load_init = '1' -- Q e deimpartit doar la inceput
                   ELSE (Q_reg(15 DOWNTO 1) & '1'); -- ce iese din AddSub e pozitiv si punem ultimul bit pe 1, altfel ramane la fel  

    Reg_Q: SHIFT_REG
        GENERIC MAP(delay => 10 ns, N => 16)
        PORT MAP(
            clock        => clock,
            reset        => reset,
            load         => Q_load_s,
            shift_en     => shift_en,
            intrare_biti => Q_load_data,
            directie     => '1',       -- shift stanga
            d_in         => '0',       -- pe ultima pozitie punem initial 0
            iesire_biti  => Q_reg,
            d_out        => Q_to_A     
        );

    Counter: numarator
        GENERIC MAP(delay => 10 ns, MAX_VAL => 16)
        PORT MAP(
            clock             => clock,
            reset             => reset,
            load              => load_init,   
            intrare_paralela  => 0,
            directie          => '1',         -- numara crescator
            enable            => shift_en,    
            iesire            => cnt_val,
            ovr               => cnt_done
        );

    -- iesire pt ControlUnit
    A_semn <= A_reg(16); --Semnul lui A, in functie de el stim daca adunam sau scadem
    count  <= cnt_done; --cnt_done a terminat cu numaratoarea
    -- iesire pt Impartitor
    cat   <= Q_reg;
    rest  <= A_reg;

END structural;
