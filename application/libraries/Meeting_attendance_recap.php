<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * CMS Sekolahku Premium Version
 * @version    2.5.4
 * @author     Anton Sofyan | https://facebook.com/antonsofyan | 4ntonsofyan@gmail.com | 0857 5988 8922
 * @copyright  (c) 2017-2023
 * @link       https://sekolahku.web.id
 *
 * PERINGATAN :
 * 1. TIDAK DIPERKENANKAN MENGGUNAKAN CMS INI TANPA SEIZIN DARI PIHAK PENGEMBANG APLIKASI.
 * 2. TIDAK DIPERKENANKAN MEMPERJUALBELIKAN APLIKASI INI TANPA SEIZIN DARI PIHAK PENGEMBANG APLIKASI.
 * 3. TIDAK DIPERKENANKAN MENGHAPUS KODE SUMBER APLIKASI.
 */

class Meeting_attendance_recap extends TCPDF {

	/**
	 * Reference to CodeIgniter instance
	 *
	 * @var object
	 */
	protected $CI;

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct('P', 'Cm', 'F4', true, 'UTF-8', false);
		$this->CI = &get_instance();
	}

	/**
	 * Overide Header
	 */
	public function Header() {

	}

	/**
	 * Overide Footer
	 */
	public function Footer() {
    	$content = '<table width="100%" border="0" cellpadding="4" cellspacing="0">';
    	$content .= '<tbody>';
    	$content .= '<tr>';
    	$content .= '<td align="left"><b>'.strtoupper(__session('school_profile')['school_name']).'</b> | Dicetak '.indo_date(date('Y-m-d')).' '.date('H:i:s').'</td>';
    	$content .= '</tr>';
    	$content .= '</tbody>';
    	$content .= '</table>';
    	$this->setY(-1);
    	$this->writeHTML($content, true, false, true, false, 'L');
	}

	/**
	 * Create PDF
	 * @param Array $params
	 */
	public function create_pdf(array $params = []) {
		$this->setHeaderFont([PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN]);
		$this->setFooterFont([PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA]);
		$this->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);
		$this->SetAutoPageBreak(TRUE, 1.3);
		$this->setImageScale(PDF_IMAGE_SCALE_RATIO);
		// Set Properties
		$this->SetTitle('LAPORAN DATA KEHADIRAN SISWA');
		$this->SetAuthor('https://sekolahku.web.id');
		$this->SetSubject(__session('school_profile')['school_name']);
		$this->SetKeywords(__session('school_profile')['school_name']);
		$this->SetCreator('https://sekolahku.web.id');
		$this->SetMargins(1, 0, 1, true);
		$this->AddPage();
		$this->SetFont('freesans', '', 10);
		// Get HTML Template
		$content = file_get_contents(VIEWPATH . 'pdf_templates/meeting_attendance_template.html');
		// Header
		$content = str_replace('[TITLE]', 'REKAPITULASI DATA KEHADIRAN SISWA', $content);
		$content = str_replace('[ACADEMIC_SEMESTER]', $params['academic_year'], $content);
		$content = str_replace('[SEMESTER]', $params['semester'], $content);
		$content = str_replace('[DATE]', $params['date'], $content);
		$content = str_replace('[TIME]', $params['time'], $content);
		$content = str_replace('[SUBJECT_NAME]', $params['subject_name'], $content);
		$content = str_replace('[CLASS_GROUP]', $params['class_group'], $content);
		$content = str_replace('[TEACHER]', $params['full_name'], $content);
		$content = str_replace('[DISCUSSION]', $params['discussion'], $content);
		// Meeting Attendances
		$H = $S = $I = $A = 0;
		$no = 1;
		$str = '';
		foreach($params['students'] as $row) {
			$str .= '<tr>';
			$str .= '<td align="center">' . $no . '.</td>';
			$str .= '<td align="center">' . $row['nis'] . '</td>';
			$str .= '<td align="left">' . $row['full_name'] . '</td>';
			$str .= '<td align="center">' . $row['gender'] . '</td>';
			$str .= '<td align="center">' . presence($row['presence']) . '</td>';
			$str .= '</tr>';
			$no++;
			if ($row['presence'] == 'present') $H++;
			if ($row['presence'] == 'sick') $S++;
			if ($row['presence'] == 'permit') $I++;
			if ($row['presence'] == 'absent') $A++;
		}
		$str .= '<tr>';
		$str .= '<td align="left" colspan="5">Total : Hadir = '.$H.', Sakit = '.$S.', Izin = '.$I.', Alpa = '.$A.'</td>';
		$str .= '</tr>';
		$content = str_replace('[PESERTA_DIDIK]', $str, $content);
		$this->writeHTML($content, true, false, true, false, 'C');
		$this->Output($params['file_name'], 'I');
	}
}

/* End of file Meeting_attendances.php */
/* Location: ./application/libraries/Meeting_attendances.php */
