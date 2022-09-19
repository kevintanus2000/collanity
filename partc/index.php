<?php
	$T = array(8, 8, 5, 7, 9, 8, 7, 4, 8);
	$temp = array();
	$output = 0;
	for($i = 0; $i < count($T); $i++)
	{
		if($i == 0)
		{
			$output += 1;
			$temp[] = $T[$i];
		}
		else
		{
			for($j = count($temp) - 1; $j >= 0; $j--)
			{
				if($T[$i] > $temp[$j])
				{
					$output += 1;
					break;
				}
				else
				{
					if($T[$i] != $temp[$j] && $j == 0)
					{
						$output += 1;
					}
					else if($T[$i] == $temp[$j])
					{
						break;
					}
				}
			}
			$temp[] = $T[$i];
		}
	}
	echo "Berdasarkan Ketinggian Dinding Pada Array (".implode(" , ",$T)."), Maka Diperoleh Jumlah Minimum Blok Untuk Membangun Dinding Yaitu '".$output."' Bagian Blok";
	
?>