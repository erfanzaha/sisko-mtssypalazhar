<?php defined('BASEPATH') OR exit('No direct script access allowed');

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

class Trigger {

   /**
	 * Reference to CodeIgniter instance
	 *
	 * @var object
	 */
    private $CI;

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
    public function __construct() {
		$this->CI = &get_instance();
		// $base_url = str_replace(['http://www.', 'https://www.', 'https://', 'http://', 'www.'], '', rtrim(base_url(), '/'));
		// $domains = ['premium-cms-sekolahku.local'];
		// foreach ($domains as $domain) {
		// 	if ($base_url !== $domain &&
		// 		$base_url !== 'ppdb.'.$domain &&
		// 		$base_url !== 'psb.'.$domain &&
		// 		strpos($base_url, 'localhost') === false
		// 	) {
		// 		exit();
		// 	}
		// }
	}

	/**
     * Set Session Here
     */
	public function index() {
		$this->CI->load->model([
			'm_settings'
			, 'm_themes'
			, 'm_form_settings'
			, 'm_academic_years'
			, 'm_admission_phases'
			, 'm_employees'
			, 'm_majors'
		]);
		$session_data = [];
		$settings = $this->CI->db->get('settings');
		foreach($settings->result() as $row) {
			$session_data[$row->setting_group][$row->setting_variable] = is_null($row->setting_value) ? $row->setting_default_value : $row->setting_value;
		}
		// Set Active Theme
		$session_data['theme'] = $this->CI->m_themes->get_active_themes();
		// Set Form Settings
		$form_settings = $this->CI->m_form_settings->get_form_settings();
		foreach($form_settings as $field => $field_setting) {
			$session_data['form_'.$field] = $field_setting;
		}
		$academic_year = $this->CI->m_academic_years->get_active_academic_year();
		// Current Admission Year
		if (isset($academic_year['admission_semester_id'])) {
			$session_data['admission_semester_id'] = $academic_year['admission_semester_id'];
		}
		if (isset($academic_year['admission_semester'])) {
			$session_data['admission_semester'] = $academic_year['admission_semester'];
		}
		if (isset($academic_year['admission_year'])) {
			$session_data['admission_year'] = $academic_year['admission_year'];
		}
		// Current Academic Year
		if (isset($academic_year['current_academic_year_id'])) {
			$session_data['current_academic_year_id'] = $academic_year['current_academic_year_id'];
		}
		if (isset($academic_year['current_academic_year'])) {
			$session_data['current_academic_year'] = $academic_year['current_academic_year'];
		}
		if (isset($academic_year['current_academic_semester'])) {
			$session_data['current_academic_semester'] = $academic_year['current_academic_semester'];
		}
		// Gelombang Pendaftaran
		$admission_phase = $this->CI->m_admission_phases->get_current_phase();
		if (count($admission_phase) > 0) {
			$session_data['admission_phase_id'] = $admission_phase['id'];
			$session_data['admission_phase'] = $admission_phase['phase_name'];
			$session_data['admission_start_date'] = $admission_phase['phase_start_date'];
			$session_data['admission_end_date'] = $admission_phase['phase_end_date'];
		}
		// Get Active Majors
		$major_count = $this->CI->m_majors->major_count();
		$session_data['major_count'] = $major_count;

		// Set Session Data
		$this->CI->session->set_userdata($session_data);
	}
}
