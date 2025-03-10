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

class Exam_cards extends TCPDF {

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
		parent::__construct('P', 'Cm', 'A4', true, 'UTF-8', false);
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
		$str = '<table width="100%" border="0" cellpadding="3" cellspacing="0" style="border-top:1px solid #000000;">';
    	$str .= '<tbody>';
    	$str .= '<tr>';
    	$str .= '<td align="left" width="60%">PPDB ' . mb_strtoupper(__session('school_profile')['school_name']) . '</td>';
    	$str .= '<td align="right" width="40%">Dicetak '.indo_date(date('Y-m-d')).' '.date('H:i:s').'</td>';
    	$str .= '</tr>';
    	$str .= '</tbody>';
    	$str .= '</table>';
    	$this->setY(-1);
    	$this->writeHTML($str, true, false, true, false, 'L');
	}

	/**
	 * Create PDF
	 * @param String $file_name
	 * @param Resource $student
	 * @param Resource $schedules
	 */
	public function pdf($res, $schedules, $file_name) {
		$this->setHeaderFont([PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN]);
		$this->setFooterFont([PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA]);
		$this->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);
		$this->SetAutoPageBreak(TRUE, 1);
		$this->setImageScale(PDF_IMAGE_SCALE_RATIO);
		// Set Properties
		$this->SetTitle('KARTU PESERTA UJIAN TES TULIS PENERIMAAN PESERTA DIDIK BARU TAHUN TAHUN ' . substr($res['registration_number'], 0, 4));
		$this->SetAuthor('https://sekolahku.web.id');
		$this->SetSubject(__session('school_profile')['school_name']);
		$this->SetKeywords(__session('school_profile')['school_name']);
		$this->SetCreator('https://sekolahku.web.id');
		$this->SetMargins(1, 1, 1, true);
		$this->AddPage();
		$this->SetFont('freesans', '', 10);

		// Get HTML Template
		$str = file_get_contents(VIEWPATH . 'pdf_templates/exam_card_template.html');
		// Header
		$str = str_replace('[LOGO]', base_url('media_library/images/'.__session('school_profile')['logo']), $str);
		$str = str_replace('[SCHOOL_NAME]', strtoupper(__session('school_profile')['school_name']), $str);
		$str = str_replace('[SCHOOL_STREET_ADDRESS]', __session('school_profile')['street_address'], $str);
		$str = str_replace('[SCHOOL_PHONE]', __session('school_profile')['phone'], $str);
		$str = str_replace('[SCHOOL_FAX]', __session('school_profile')['fax'], $str);
		$str = str_replace('[SCHOOL_POSTAL_CODE]', __session('school_profile')['postal_code'], $str);
		$str = str_replace('[SCHOOL_EMAIL]', __session('school_profile')['email'], $str);
		$str = str_replace('[SCHOOL_WEBSITE]', str_replace(['http://', 'https://', 'www.'], '', __session('school_profile')['website']), $str);
		$str = str_replace('[TITLE]', 'KARTU PESERTA UJIAN TES TULIS PENERIMAAN PESERTA DIDIK BARU TAHUN ' . substr($res['registration_number'], 0, 4), $str);
		$str = str_replace('[IS_TRANSFER]', (filter_var($res['is_transfer'], FILTER_VALIDATE_BOOLEAN) ? 'Siswa Pindahan':'Siswa Baru'), $str);
		$str = str_replace('[ADMISSION_TYPE]', $res['admission_type'] ?? '', $str);
		$str = str_replace('[ADMISSION_PHASE]', $res['phase_name'] ?? '', $str);
		$str = str_replace('[ACADEMIC_YEAR]', (substr($res['registration_number'], 0, 4) . '/' . (substr($res['registration_number'], 0, 4) + 1)) ?? '', $str);
		$str = str_replace('[REGISTRATION_NUMBER]', $res['registration_number'] ?? '', $str);
		$str = str_replace('[CREATED_AT]', indo_date(substr($res['created_at'], 0, 10)) ?? '', $str);
		$str = str_replace('[FULL_NAME]', $res['full_name'] ?? '', $str);
		if ( filter_var(__session('form_first_choice_id')['admission'], FILTER_VALIDATE_BOOLEAN)) {
			$replace = '<table width="100%" border="1" cellpadding="6" cellspacing="0" style="border: 0.001em solid black;">';
			$replace .= '<tr><td width="100%" align="left" colspan="2" style="font-weight: bold; font-size: 14px;">DATA PEMINATAN</td></tr>';
			$replace .= '<tr>';
			$replace .= '<td width="50%" style="background-color: #dddddd; font-weight: bold;" align="left">Pilihan Ke-1</td>';
			$replace .= '<td width="50%" style="background-color: #dddddd; font-weight: bold;" align="left">Pilihan Ke-2</td>';
			$replace .= '</tr>';
			$replace .= '<tr><td align="left" width="50%">' . $res['first_choice'] . '</td><td align="left" width="50%">' . $res['second_choice'] . '</td></tr>';
			$replace .= '</table>';
			$replace .= '<table width="100%" border="0" cellpadding="0" cellspacing="0"><tr><td></td></tr></table>';
			$str = str_replace('[MAJORS]', $replace, $str);
		} else {
			$str = str_replace('[MAJORS]', '', $str);
		}
		$exam_schedules = '';
		foreach($schedules->result() as $row) {
			$exam_schedules .= '<tr>';
            $exam_schedules .= '<td align="left">' . indo_date($row->exam_date) . '</td>';
            $exam_schedules .= '<td align="left">' . substr($row->exam_start_time, 0, 5) . ' - ' . substr($row->exam_end_time, 0, 5) . '</td>';
            $exam_schedules .= '<td align="left">' . $row->subject_name . '</td>';
            $exam_schedules .= '<td align="left">' . $row->building_name . ' / ' . $row->room_name . '</td>';
        	$exam_schedules .= '</tr>';
		}
		$str = str_replace('[EXAM_SCHEDULES]', $exam_schedules ?? '', $str);
		$style = array(
			'border' => 1,
			'vpadding' => 1,
			'hpadding' => 1,
			'fgcolor' => array(0,0,0),
			'bgcolor' => false,
			'module_width' => 1,
			'module_height' => 1
		);
		$this->write2DBarcode($res['registration_number'] ?? '', 'QRCODE', 17, 1, 4, 4, $style);
		$this->writeHTML($str, true, false, true, false, 'C');
		$this->Output($file_name, 'I');
	}
}

/* End of file Exam_cards.php */
/* Location: ./application/libraries/Exam_cards.php */
