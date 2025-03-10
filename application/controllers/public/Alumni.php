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

class Alumni extends Public_Controller {

	/**
	 * Index
	 * @return Void
	 */
	public function index() {
		$this->load->helper('form');
		$this->vars['page_title'] = 'Pendaftaran Alumni';
		$this->vars['content'] = 'themes/'.theme_folder().'/alumni-form';
		$this->load->view('themes/'.theme_folder().'/index', $this->vars);
	}

	/**
	 * save
	 * @return Object
	 */
	public function save() {
		if ($this->input->is_ajax_request()) {
			if (__captchaActivated()) {
				$score = get_recapture_score($this->input->post('g-recaptcha-response'));
				if ($score < 0.9) {
					$this->vars['status'] = 'recaptcha_error';
	    			$this->vars['message'] = 'Recaptcha Error!';
					$this->output
						->set_content_type('application/json', 'utf-8')
						->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
						->_display();
					exit;
				}
			}

			if ($this->validation()) {
				$dataset = $this->dataset();
				// Photo Uploaded
				$has_uploaded = false;
				if ( ! empty($_FILES['photo']['name']) ) {
					$photo = $this->upload_file();
					if ($photo['status'] == 'success') {
						$has_uploaded = true;
						$dataset['photo'] = $photo['file_name'];
					} else {
						$this->vars['status'] = $photo['status'];
						$this->vars['message'] = $photo['message'];
						$this->output
							->set_content_type('application/json', 'utf-8')
							->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
							->_display();
						exit;
					}
				}

				$query = $this->model->insert('users', $dataset);
				$this->vars['status'] = $query ? 'success' : 'error';
				$this->vars['message'] = $query ? 'Data Anda berhasil disimpan.' : 'Terjadi kesalahan dalam menyimpan data';
				if ( ! $query && $has_uploaded) {
					@unlink(FCPATH.'media_library/users/photo/'.$photo['file_name']);
				}
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
	 * Dataset
	 * @return Array
	 */
	private function dataset() {
		return [
			'created_by' => __session('user_id'),
			'is_alumni' => 'unverified',
			'nis' => $this->input->post('nis', true),
			'full_name' => $this->input->post('full_name', true),
			'gender' => $this->input->post('gender', true),
			'birth_place' => $this->input->post('birth_place', true),
			'birth_date' => $this->input->post('birth_date', true),
			'start_date' => $this->input->post('start_date', true).'-07-01',
			'end_date' => $this->input->post('end_date', true).'-06-20',
			'street_address' => $this->input->post('street_address', true),
			'email' => $this->input->post('email', true) ? $this->input->post('email', true) : NULL,
			'phone' => $this->input->post('phone', true),
			'mobile_phone' => $this->input->post('mobile_phone', true)
		];
	}

	/**
	 * Validation Form
	 * @return Boolean
	 */
	private function validation() {
		$this->load->library('form_validation');
		$val = $this->form_validation;
		$val->set_rules('full_name', 'Nama Lengkap', 'trim|required');
		$val->set_rules('gender', 'Jenis Kelamin', 'trim|required');
		$val->set_rules('birth_place', 'Tempat Lahir', 'trim|required');
		$val->set_rules('birth_date', 'Tanggal Lahir', 'trim|required|callback_date_format_check');
		$val->set_rules('start_date', 'Tahun Masuk', 'trim|required|min_length[4]|max_length[4]|numeric');
		$val->set_rules('end_date', 'Tahun Lulus', 'trim|required|min_length[4]|max_length[4]|numeric');
		$val->set_rules('nis', 'NIS', 'trim|callback_nis_exists');
		$val->set_rules('street_address', 'ALamat Jalan', 'trim|required');
		$val->set_rules('email', 'Email', 'trim|required|valid_email|callback_email_exists');
		$val->set_rules('phone', 'Nomor Telepon', 'trim');
		$val->set_rules('mobile_phone', 'Nomor Handphone', 'trim|required');
		$val->set_message('required', '{field} harus diisi');
		$val->set_message('valid_email', '{field} harus diisi dengan format email yang benar');
		$val->set_error_delimiters('<div>&sdot; ', '</div>');
		return $val->run();
	}

	/**
	 * nis (NIS) Exists?
	 * @param String $nis
	 * @return Boolean
	 */
	public function nis_exists( $nis = NULL, $id = 0 ) {
		$this->load->model('m_users');
		$nis_exists = $this->m_users->nis_exists( $nis, $id );
		if ( $nis_exists ) {
			$this->form_validation->set_message('nis_exists', 'NIS sudah digunakan');
			return FALSE;
		}
		return TRUE;
	}

	/**
	 * Email Exists?
	 * @param String $email
	 * @param Integer $id
	 * @return Boolean
	 */
	public function email_exists( $email = '', $id = 0 ) {
		$this->load->model('m_users');
		$email_exists = $this->m_users->email_exists( $email, $id );
		if ( $email_exists ) {
			$this->form_validation->set_message('email_exists', 'Email sudah digunakan');
			return FALSE;
		}
		return TRUE;
	}

	/**
	 * Date Format Check
	 * @param String $date
	 * @return Boolean
	 */
	public function date_format_check($date) {
		if ( ! _isValidDate($date)) {
			 $this->form_validation->set_message('date_format_check', '{field} harus diisi dengan format YYYY-MM-DD');
			 return FALSE;
	   }
		 return TRUE;
	 }

	/**
	  * Upload File
	  * @return Array
	  */
	private function upload_file() {
		$config['upload_path'] = './media_library/users/photo';
		$config['allowed_types'] = 'jpg|jpeg|png';
		$config['max_size'] = 512; // 512 KB
		$config['encrypt_name'] = TRUE;
		$this->load->library('upload');
		$this->upload->initialize($config);
		if ( ! $this->upload->do_upload('photo') ) {
			$this->vars['status'] = 'error';
			$this->vars['message'] = $this->upload->display_errors();
			$this->vars['file_name'] = '';
		} else {
			$file = $this->upload->data();
			@chmod(FCPATH.'media_library/users/photo/' . $file['file_name'], 0777);
			$this->image_resize(FCPATH.'media_library/users/photo/', $file['file_name']);
			$this->vars['status'] = 'success';
			$this->vars['message'] = 'uploaded';
			$this->vars['file_name'] = $file['file_name'];
		}
		return $this->vars;
	}

	/**
	 * Image Resize
	 * @param String $path
	 * @param String $file_name
	 * @return Void
	 */
	private function image_resize($path, $file_name) {
		$this->load->library('image_lib');
		$config['image_library'] = 'gd2';
		$config['source_image'] = $path .'/'.$file_name;
		$config['maintain_ratio'] = TRUE;
		$config['width'] = NULL !== __session('media')['user_photo_width'] && __session('media')['user_photo_width'] > 0 ? (int) __session('media')['user_photo_width'] : 250;
		$this->image_lib->initialize($config);
		$this->image_lib->resize();
	}
}
