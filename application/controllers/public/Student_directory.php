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

class Student_directory extends Public_Controller {

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$this->load->helper('form');
		$this->load->model([
			'm_students',
			'm_academic_years',
			'm_class_groups',
			'public/m_class_group_students'
		]);
	}

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$this->vars['page_title'] = 'DIREKTORI PESERTA DIDIK TAHUN PELAJARAN ' . __session('current_academic_year');
		$this->vars['academic_year_dropdown'] = $this->m_academic_years->dropdown();
		$this->vars['class_group_dropdown'] = $this->m_class_groups->dropdown();
		$this->vars['content'] = 'themes/'.theme_folder().'/loop-students';
		$this->load->view('themes/'.theme_folder().'/index', $this->vars);
	}

	/**
	 * Search Students
	 * @return Object
	 */
	public function get_students() {
		if ($this->input->is_ajax_request()) {
			if ($this->validation()) {
				$academic_year_id = _toInteger($this->input->post('academic_year_id', true));
				$class_group_id = _toInteger($this->input->post('class_group_id', true));
				$query = $this->m_class_group_students->get_students($academic_year_id, $class_group_id);
				$rows = [];
				foreach($query->result() as $row) {
					$photo = 'no-image.png';
					if ($row->photo && file_exists($_SERVER['DOCUMENT_ROOT'] . '/media_library/users/photo/'.$row->photo)) {
						$photo = $row->photo;
					}
					$rows[] = [
						'nis' => $row->nis,
						'full_name' => $row->full_name,
						'gender' => $row->gender == 'L' ? 'Laki-laki' : 'Perempuan',
						'birth_place' => $row->birth_place,
						'birth_date' => indo_date($row->birth_date),
						'photo' => base_url('media_library/users/photo/'.$photo)
					];
				}
				$this->vars['rows'] = $rows;
			} else {
				$this->vars['status'] = 'error';
				$this->vars['message'] = validation_errors();
			}
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}

	/**
	 * Validation Form
	 * @return Boolean
	 */
	private function validation() {
		$this->load->library('form_validation');
		$val = $this->form_validation;
		$val->set_rules('academic_year_id', 'Tahun Pelajaran', 'trim|required|numeric');
		$val->set_rules('class_group_id', 'Kelas', 'trim|required|numeric');
		$val->set_error_delimiters('<div>&sdot; ', '</div>');
		return $val->run();
	}
}
