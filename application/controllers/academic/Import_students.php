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

class Import_students extends Admin_Controller {

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$this->vars['title'] = 'Import Peserta Didik';
		$this->vars['academic'] = $this->vars['academic_import'] = $this->vars['import_students'] = TRUE;
		$this->vars['content'] = 'academic/import_students';
		$this->load->view('backend/index', $this->vars);
	}

	/**
	 * Save
	 */
	public function save() {
		if ($this->input->is_ajax_request()) {
			$rows = explode("\n", $this->input->post('students'));
			foreach($rows as $row) {
				$split = explode("\t", $row);
				if (count($split) != 6) continue;
				$nis_exists = $this->model->is_exists('nis', trim($split[0]), 'users');
				if ( $nis_exists ) continue;
				$this->db->set('nis', trim($split[0]));
				$this->db->set('full_name', trim($split[1]));
				$this->db->set('gender', trim($split[2]) == 'L' ? 'M' : 'F');
				$this->db->set('street_address', trim($split[3]));
				$this->db->set('birth_place', trim($split[4]));
				$this->db->set('birth_date', trim($split[5]));
				$this->db->set('is_student', 'true');
				$this->db->set('citizenship', 'WNI');
				$this->db->set('student_status_id', get_option_id('student_status', 'aktif'));
				$this->db->set('email', trim($split[0]).'@'.str_replace(['http://', 'https://', 'www.'], '', rtrim(__session('school_profile')['website'], '/')));
				$this->db->set('password', password_hash(trim($split[5]), PASSWORD_BCRYPT, ['cost' => 12]));
				$this->db->set('created_by', __session('user_id'));
				$query_string = $this->db->get_compiled_insert('users');
				$query_string = str_replace('INSERT INTO', 'INSERT IGNORE INTO', $query_string);
        		$this->db->query($query_string);
			}
			$this->vars['status'] = 'success';
			$this->vars['message'] = 'Data Peserta Didik sudah tersimpan';
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}
}
