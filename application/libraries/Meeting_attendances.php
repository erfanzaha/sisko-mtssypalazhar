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

class Meeting_attendances extends TCPDF {

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
    	$str = '<table width="100%" border="0" cellpadding="4" cellspacing="0" style="border-top:1px solid #000;">';
    	$str .= '<tbody>';
    	$str .= '<tr>';
    	$str .= '<td align="left"><b>'.strtoupper(__session('school_profile')['school_name']).'</b> | Dicetak '.indo_date(date('Y-m-d')).' '.date('H:i:s').'</td>';
    	$str .= '</tr>';
    	$str .= '</tbody>';
    	$str .= '</table>';
    	$this->setY(-1);
    	$this->writeHTML($str, true, false, true, false, 'L');
	}

	/**
	 * Create PDF
	 * @param Array $params
	 */
	public function pdf(array $params = []) {
		$this->setHeaderFont([PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN]);
		$this->setFooterFont([PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA]);
		$this->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);
		$this->SetAutoPageBreak(TRUE, 1.43);
		$this->setImageScale(PDF_IMAGE_SCALE_RATIO);
		// Set Properties
		$this->SetTitle('LAPORAN DATA KEHADIRAN SISWA');
		$this->SetAuthor('https://sekolahku.web.id');
		$this->SetSubject(__session('school_profile')['school_name']);
		$this->SetKeywords(__session('school_profile')['school_name']);
		$this->SetCreator('https://sekolahku.web.id');
		$this->SetMargins(1.5, 1.5, 1.5, TRUE);
		$this->AddPage();
		$this->SetFont('freesans', '', 10);
		$str = file_get_contents(VIEWPATH . 'pdf_templates/meeting_attendance_template.html');
		$str = str_replace('[LOGO]', base_url('media_library/images/'.__session('school_profile')['logo']), $str);
		$str = str_replace('[SCHOOL_NAME]', strtoupper(__session('school_profile')['school_name']), $str);
		$str = str_replace('[SCHOOL_STREET_ADDRESS]', __session('school_profile')['street_address'], $str);
		$str = str_replace('[SCHOOL_PHONE]', __session('school_profile')['phone'], $str);
		$str = str_replace('[SCHOOL_FAX]', __session('school_profile')['fax'], $str);
		$str = str_replace('[SCHOOL_POSTAL_CODE]', __session('school_profile')['postal_code'], $str);
		$str = str_replace('[SCHOOL_EMAIL]', __session('school_profile')['email'], $str);
		$str = str_replace('[SCHOOL_WEBSITE]', str_replace(['http://', 'https://', 'www.'], '', __session('school_profile')['website']), $str);
		$str = str_replace('[ACADEMIC_SEMESTER]', $params['academic_year'], $str);
		$str = str_replace('[SEMESTER]', $params['semester'], $str);
		$str = str_replace('[DATE]', $params['date'], $str);
		$str = str_replace('[TIME]', $params['time'], $str);
		$str = str_replace('[SUBJECT_NAME]', $params['subject_name'], $str);
		$str = str_replace('[CLASS_GROUP]', $params['class_group'], $str);
		$str = str_replace('[TEACHER]', $params['full_name'], $str);
		$str = str_replace('[DISCUSSION]', $params['discussion'] ?? '', $str);
		$str = str_replace('[ACADEMIC_YEAR]', 'Tahun Pelajaran', $str);
		// Meeting Attendances
		$H = $S = $I = $A = 0;
		$no = 1;
		$students = '';
		foreach($params['students'] as $row) {
			$students .= '<tr>';
			$students .= '<td width="7%" align="center">' . $no . '.</td>';
			$students .= '<td width="25%" align="center">' . $row['nis'] . '</td>';
			$students .= '<td width="48%" align="left"> ' . $row['full_name'] . '</td>';
			$students .= '<td width="10%" align="center">' . $row['gender'] . '</td>';
			$students .= '<td width="10%" align="center">' . presence($row['presence']) . '</td>';
			$students .= '</tr>';
			$no++;
			if ($row['presence'] == 'present') $H++;
			if ($row['presence'] == 'sick') $S++;
			if ($row['presence'] == 'permit') $I++;
			if ($row['presence'] == 'absent') $A++;
		}
		$students .= '<tr>';
		$students .= '<td align="left" colspan="5">Total : Hadir = '.$H.', Sakit = '.$S.', Izin = '.$I.', Alpa = '.$A.'</td>';
		$students .= '</tr>';
		$str = str_replace('[PESERTA_DIDIK]', $students, $str);
		$this->writeHTML($str, true, false, true, false, 'C');
		$this->Output($params['file_name'], 'I');
	}
}

/* End of file Meeting_attendances.php */
/* Location: ./application/libraries/Meeting_attendances.php */
