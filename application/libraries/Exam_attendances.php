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

class Exam_attendances extends TCPDF {

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
    	$content = '<table width="100%" border="0" cellpadding="3" cellspacing="0" style="border-top:1px solid #000000;">';
    	$content .= '<tbody>';
    	$content .= '<tr>';
    	$content .= '<td align="right">Dicetak '.indo_date(date('Y-m-d')).' '.date('H:i:s').'</td>';
    	$content .= '</tr>';
    	$content .= '</tbody>';
    	$content .= '</table>';
    	$this->setY(-1);
    	$this->writeHTML($content, true, false, true, false, 'L');
	}

	/**
	 * Create PDF
	 * @param Object $header
	 * @param Resource $students
	 */
	public function pdf($header, $students) {
		$this->setHeaderFont([PDF_FONT_NAME_MAIN, '', PDF_FONT_SIZE_MAIN]);
		$this->setFooterFont([PDF_FONT_NAME_DATA, '', PDF_FONT_SIZE_DATA]);
		$this->SetDefaultMonospacedFont(PDF_FONT_MONOSPACED);
		$this->SetAutoPageBreak(TRUE, 1.6);
		$this->setImageScale(PDF_IMAGE_SCALE_RATIO);
		// Set Properties
		$this->SetTitle('DAFTAR HADIR UJIAN TES TULIS PENERIMAAN PESERTA DIDIK BARU TAHUN '.__session('admission_year'));
		$this->SetAuthor('https://sekolahku.web.id');
		$this->SetSubject(__session('school_profile')['school_name']);
		$this->SetKeywords(__session('school_profile')['school_name']);
		$this->SetCreator('https://sekolahku.web.id');
		$this->SetMargins(1, 1, 1, true);
		$this->AddPage();
		$this->SetFont('freesans', '', 10);

		// Get HTML Template
		$content = file_get_contents(VIEWPATH . 'pdf_templates/exam_attendance_template.html');
		// Header
		$content = str_replace('[LOGO]', base_url('media_library/images/'.__session('school_profile')['logo']), $content);
		$content = str_replace('[SCHOOL_NAME]', strtoupper(__session('school_profile')['school_name']), $content);
		$content = str_replace('[SCHOOL_STREET_ADDRESS]', __session('school_profile')['street_address'], $content);
		$content = str_replace('[SCHOOL_PHONE]', __session('school_profile')['phone'], $content);
		$content = str_replace('[SCHOOL_FAX]', __session('school_profile')['fax'], $content);
		$content = str_replace('[SCHOOL_POSTAL_CODE]', __session('school_profile')['postal_code'], $content);
		$content = str_replace('[SCHOOL_EMAIL]', __session('school_profile')['email'], $content);
		$content = str_replace('[SCHOOL_WEBSITE]', str_replace(['http://', 'https://', 'www.'], '', __session('school_profile')['website']), $content);
		$content = str_replace('[TITLE]', 'DAFTAR HADIR UJIAN TES TULIS<br>PENERIMAAN PESERTA DIDIK BARU TAHUN '.__session('admission_year'), $content);
		// Registrasi Peserta Didik
		$content = str_replace('[ADMISSION_SEMESTER]', $header->academic_year, $content);
		$content = str_replace('[EXAM_DATE]', indo_date($header->exam_date), $content);
		$content = str_replace('[ADMISSION_TYPE]', $header->admission_type, $content);
		$content = str_replace('[EXAM_TIME]', substr($header->exam_start_time, 0, 5).' s.d '. substr($header->exam_end_time, 0, 5), $content);
		$content = str_replace('[SUBJECT_NAME]', $header->subject_name, $content);
		$content = str_replace('[EXAM_LOCATION]', 'Gedung ' . str_replace(['Gedung', 'gedung'], '', $header->building_name).' Ruang '. str_replace(['Ruang', 'ruang'], '', $header->room_name), $content);
		if (__session('major_count') > 0) {
			$content = str_replace('[MAJOR_LABEL]', 'Jurusan', $content);
			$content = str_replace('[MAJOR_LABEL]', 'Program Keahlian', $content);
			$content = str_replace('[MAJOR_SEPARATOR]', ':', $content);
			$content = str_replace('[MAJOR_NAME]', (isset($header->major_name) ? $header->major_name : '-'), $content);
		} else {
			$content = str_replace('[MAJOR_LABEL]', '', $content);
			$content = str_replace('[MAJOR_SEPARATOR]', '', $content);
			$content = str_replace('[MAJOR_NAME]', '', $content);
		}
		$content = str_replace('[COUNT]', $students->num_rows().' orang', $content);
		if ($students->num_rows() > 0) {
			$str = '<table width="100%" border="1" cellpadding="8" cellspacing="0"><tbody>';
			$no = 1;
			foreach($students->result() as $row) {
				$str .= '<tr>';
				$str .= '<td width="8%" align="right">'.$no.'.</td>';
				$str .= '<td width="20%" align="center" valign="center">'.$row->registration_number.'</td>';
				$str .= '<td width="42%" align="left" valign="center">'.$row->full_name.'</td>';
				$str .= '<td width="15%"></td>';
				$str .= '<td width="15%"></td>';
				$str .= '</tr>';
				$no++;
			}
			$str .= '</table>';
			$content = str_replace('[STUDENTS]', $str, $content);
		}
		$file_name = 'daftar-hadir-ujian-tes-tulis-penerimaan-peserta-didik-baru-tahun-'.__session('admission_year') . '-' . time() . '.pdf';
		$this->writeHTML($content, true, false, true, false, 'C');
		$this->Output($file_name, 'I');
	}
}

/* End of file Exam_attendances.php */
/* Location: ./application/libraries/Exam_attendances.php */
