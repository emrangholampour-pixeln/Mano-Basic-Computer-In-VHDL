----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:46:10 07/20/2024 
-- Design Name: 
-- Module Name:    finale_project - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity basic_computer_of_mano1 is
    Generic( 
        AddW : INTEGER := 7;
        DataW : INTEGER := 16
    );
    Port (
        R : out STD_LOGIC := '0';
		  int : in std_logic := '0';
        data : in unsigned (15 DOWNTO 0) := (OTHERS => '0');
        start : in STD_LOGIC;
        clock : in STD_LOGIC := '0';
        IR : out unsigned (15 DOWNTO 0) := (OTHERS => '0');
        AC : out unsigned (15 DOWNTO 0) := (OTHERS => '0');
        SP : out unsigned (11 DOWNTO 0) := (OTHERS => '0');
        E : out STD_LOGIC		  ;
        DR : out unsigned (15 DOWNTO 0) := (OTHERS => '0');
        OUTR : out unsigned (7 DOWNTO 0) := (OTHERS => '0');
        IEN : out STD_LOGIC;
        temp : out unsigned (15 DOWNTO 0) := (OTHERS => '0');
        RAMout : out unsigned (15 DOWNTO 0);
        PC : out unsigned (11 DOWNTO 0) := (OTHERS => '0');
		  AR : OUT unsigned (11 DOWNTO 0) := (OTHERS => '0');
		  I  : OUT STD_LOGIC:= '0' ; 
		  D : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		  S  : OUT STD_LOGIC :='0';
		  AC_hold : out unsigned (16 downto 0);
		  T  : out integer
    );
end basic_computer_of_mano1;

architecture Behavioral of basic_computer_of_mano1 is
    signal int_PC : unsigned (11 downto 0) := to_unsigned(70, 12);
    signal int_IR : unsigned (15 downto 0) := (others => '0');
    signal int_DR : unsigned (15 downto 0) := (others => '0');
    signal int_AC : unsigned (15 downto 0) := "1011100010101000";
    signal int_SP : unsigned (11 downto 0) := to_unsigned(91,12);
    signal int_OUTR : unsigned (7 downto 0) := (OTHERS => '0');
    signal int_IEN : std_logic := '1';
    signal WA_signal : unsigned (11 downto 0) := to_unsigned(69, 12);
    signal Din_signal : unsigned (15 downto 0) := (others => '0');
    signal WE_signal : std_logic := '1';
    signal Dout_signal : unsigned (15 downto 0) := (others => '0');
    signal Ac_holder : unsigned (16 downto 0) := (others => '0');
	 signal int_R        :std_logic :='0';
	 SIGNAL int_AR : UNSIGNED (11 DOWNTO 0) := (others =>'0');
	 signal int_D  : std_logic_VECTOR (7 DOWNTO 0) := (others =>'0');
	 SIGNAL B      : unsigned  (11 DOWNTO 0 ):= (others =>'0');
	 signal int_E : std_logic :='1';
	 signal int_I : std_logic :='0';
	 SIGNAL int_S : std_logic :='1';
	 signal int_T : integer :=0;

begin

    Inst_BlockRAM: entity work.BlockRAM
        port map (
            WA => WA_signal,
            Din => Din_signal,
            clock => clock,
            WE => WE_signal,
            RA => int_AR,
            Dout => Dout_signal,
            temp => temp
        );
    IR <= int_IR;
    DR <= int_DR;
    AC <= int_AC;
    SP <= int_SP;
    IEN <= int_IEN;
    OUTR <= int_OUTR;
    PC <= int_PC;
    RAMout <= Dout_signal;
	 R<=int_R;
	 AR<=int_AR;
	 D<=int_D;
	 E<=int_E;
	 I<=int_I;
	 AC_hold<=Ac_holder;
	 S<=int_S;
	 T<=int_T;
    process (int,int_IEN,clock,int_T,int_S)
    begin
	      IF(int_S='0')THEN
			          assert false report "Simulation finished" severity note;
			END IF ;
        if    int_T/=0 and int_T/=1 and int_T/=2 AND int_T/=3 and int_T/=4 then
		             if int_IEN = '1' and int='1' then
                       int_R <= '1';
					    end if ;
        end if;

        if rising_edge(clock) then
		   
            if int_R = '1' then --intrupt cickle
					      if(int_T=0)THEN --ien=0;
							  int_IEN <= '0';
							  int_SP <= int_SP - 1;
							  int_T<=int_T+1;
							END IF ;
							IF(int_T=1)THEN
							   WE_signal <= '1';
                        WA_signal <= int_SP;
							   Din_signal <= int_AC;
								int_T<=int_T+1;
							END IF ;
                     IF(int_T=2)THEN --push ac;
							   WE_signal <= '0';
								int_SP <= int_SP - 1;
								int_T<=int_T+1;
							END IF ;
                     IF(int_T=3)THEN
							    WE_signal <= '1';
                         WA_signal <= int_SP;
							    Din_signal(11 downto 0) <= int_PC;
								 int_T<=int_T+1;
							 end if ;
							  if(int_T=4)THEN
							    WE_signal <= '0';
								 int_PC<=to_unsigned(1,12);
								 int_R<='0';
								 int_T<=0;
							  END IF ;
							END IF;  --R=1
      

            if start = '1' then
                WA_signal <= WA_signal + 1;
                Din_signal <= data;
                if WA_signal = to_unsigned(80, 7) then
                    WE_signal <= '0';
                end if;
            end if;

            if (start = '0' and int_R = '0') then --instruction cikle
				     if(int_T=0)THEN
					     int_AR<=int_PC;
						  int_T<=int_T+1;
					  end if ;--T0
					    if (int_T=1)THEN
					        int_T <= int_T + 1;
					    end if ;--T1
				      if(int_T=2)THEN
					
					        int_IR<=Dout_signal;
					        int_PC<=int_PC+1;
							
							  if(int_PC=to_unsigned(73,12))then
							    int_PC<=to_unsigned(73,12);
							  end if ;
							 if(int_PC=to_unsigned(1,12))then
							    int_PC<=to_unsigned(1,12);
							  end if ;
							 if(int_PC=to_unsigned(80,12))then
							    int_PC<=to_unsigned(80,12);
							 end if ;
						     int_T<=int_T+1;		
				    end if; --T2
				if(int_T=3)THEN
										 int_AR<=int_IR(11 downto 0);
										 B<=int_IR(11 downto 0);
										 int_I<=int_IR(15);
										 CASE int_IR(14 downto 12) is 
										  when "000" => int_D(0) <= '1';
										  when "001" => int_D(1) <= '1';
										  when "010" => int_D(2) <= '1';
										  when "011" => int_D(3) <= '1';
										  when "100" => int_D(4) <= '1';
										  when "101" => int_D(5) <= '1';
										  when "110" => int_D(6) <= '1';
										  when "111" => int_D(7) <= '1';
										  when OTHERS => int_D<=(OTHERS=>'0');
										  end case ;
										  int_T<=int_T+1;
              
          end if ;--T3
			   if(int_T=4)THEN
				   int_T<=int_T+1;
				END IF ;
			end if;--R=0
            IF(int_T=5)THEN			 
                IF (int_D(7)='1')then 
                            if(int_I='0')then --rigister instruction 
									    if (B(11)='1')then --CLA
										    int_AC<=(others=>'0');
											 int_T<=0;
											 int_D<="00000000";
										 end if ;--CLA
										 if(B(10)='1')THEN --CLE
										   int_E<='0';
											int_T<=0;
											int_D<="00000000";
										 END IF ;--CLE
										 if(B(9)='1')THEN --CMA
										    int_AC<=not(int_AC);
											 int_T<=0;
											int_D<="00000000";
										 END IF ;--CMA
										 if(B(8)='1')THEN --CME
										   int_E<=not(int_E);
											int_T<=0;
											int_D<="00000000";
										 END IF;--CME
										 if(B(7)='1')then --CIR
										   int_AC<= int_E & int_AC (15 DOWNTO 1);
										   int_E<=int_AC(0);
										   int_T<=0;
											int_D<="00000000";
										 end if ;--CIR
										 if(B(6)='1')then --CIL
										   int_AC<=int_AC(14 downto 0)&int_E;
											int_E<=int_AC(15);
											int_T<=0;
											int_D<="00000000";
										 end if ;--CIL
										 if (B(5)='1')THEN --INC
												 int_AC<=int_AC+1;
												 int_T<=0;	
                                     int_D<="00000000";												 
											END IF ;--INC
											if (B(4)='1')then --SPA
											   IF(int_AC(15)='0')THEN
												   int_AC<=int_AC+1;											
												END IF ;
													int_T<=0;
													int_D<="00000000";
											end if ;--SPA
											if (B(3)='1') then --SNA
											   IF(int_AC(15)='1')THEN
												   int_PC<=int_PC+1;											
												END IF ;
												int_T<=0;
												int_D<="00000000";
											end if ;--SNA
											if(B(2)='1')then --SZA
											    if(int_AC ="0000000000000000") THEN
											       int_PC<=int_PC+1;
											     END IF ; 
												int_T<=0;		
												int_D<="00000000";
											END IF ;--SZA
											if(B(1)='1')THEN--SZE
											  if(int_E ='0') THEN
											     int_PC<=int_PC+1;
											   END IF ; 
												int_T<=0;	
												int_D<="00000000";
											END IF ;--SZE
											if(B(0)='1')then --HLT
											   int_S<='0';
												int_T<=0;		
												int_D<="00000000";
											end if ;--HLT
									 ELSE --i=1;I/O
									     if(B(10)='1')then --OUT
										    int_OUTR<=int_AC(7 downto 0);
											 int_T<=0;		
											int_D<="00000000";
										  end if ;--OUT
										  if(B(7)='1')then -- ION
										    int_IEN <= '1';
											 int_T<=0;		
											int_D<="00000000";
										  end if ;-- ION
										  
									end if ;--i=0
  					  else --D(7)=0;
						           if(int_I='1')then --non_direct_addressing
										    int_AR<=Dout_signal(11 DOWNTO 0);
											 int_T<=int_T + 1;
									  else 
											    int_T<=int_T + 1;
										end if ;--I=1;
										
							END IF;--D{7)=1;
				END IF;--T=5
		
		               IF(int_T=6)THEN
								   int_T<=int_T + 1;
						   END IF ;
							         IF(int_D(2)='1')THEN --LDA
										     IF(int_T=7)THEN
										     int_DR<=Dout_signal;
											  int_T<=int_T+1;
											  END IF ;
											if(int_T=8)THEN
											   int_AC<=int_DR;
												int_T<=0;
												int_D<="00000000";
											END IF ;
										END IF ;							
									if(int_D(1)='1')then --ADD
											  if(int_T=7)then--T7
										     int_DR<=Dout_signal;
											  int_T<=int_T+1;
											  end if ;--T7
											  if(int_T=8)THEN
											      Ac_holder<= int_AC+ resize(int_DR,17);
												   int_T<=int_T+1;
												END IF ;
											  if(int_T=9)THEN 
											     int_AC<=Ac_holder(15 DOWNTO 0);
												  int_E<=Ac_holder(16);
												  int_T<=0;
												  int_D<="00000000";
											  END IF ;
									 end if ;--add
										 if(int_D(4)='1')then--BUN 
										   if(int_T=7)THEN --T7
										     int_PC<=int_AR;
											  int_T<=0;
											  int_D<="00000000";
											 END IF ;
										 end if ;--bun--70
										 if(int_D(6)='1')then --	RET 
										   if(int_T=7)THEN --T7
										      int_AR<=int_SP;
			                           int_T<=int_T+1;
											 END IF ;
											 if(int_T=8)THEN -- T8
			                           int_T<=int_T+1;
											 END IF ;
											 if(int_T=9)THEN --  T9
										      int_PC <= Dout_signal(11 downto 0);	  
			                           int_T<=int_T+1;
											 END IF ;
											 if(int_T=10)THEN --  T10
											   int_SP<=int_SP+1;
												int_T<=int_T+1;
											 END IF ;
											 if(int_T=11)then
											    int_AR<=int_SP;
												 int_T<=int_T+1;
											 end if ;
											 if(int_T=12)then
											    int_T<=int_T+1;
											 end if ;
											 if(int_T=13)then
											    int_AC <= Dout_signal;
											    int_T<=int_T+1;
											 end if ;
											  if(int_T=14)then
											    int_SP<=int_SP+1;
											    int_T<=0;
												 int_D<="00000000";
												 int_OUTR<=to_unsigned (0,8);
											 end if ;
										 end if ; --	RET
				end if ;--rising_edge
		end process ;
end behavioral;