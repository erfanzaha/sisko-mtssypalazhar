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

class Admin_Controller extends MY_Controller {

	/**
	 * Primary key
	 * @var string
	 */
	protected $pk;

	/**
	 * Table
	 * @var string
	 */
	protected $table;

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();

		// Restrict
		$this->auth->restrict();

		// Check privileges Users
		if ( ! in_array($this->uri->segment(1), __session('user_privileges'))) {
			return redirect(base_url());
		}
		// $this->output->enable_profiler();
	}

	/**
	 * deleted data | SET is_deleted to true
	 */
	public function delete() {
		if ($this->input->is_ajax_request()) {
			$this->vars['status'] = 'warning';
			$this->vars['message'] = 'not_selected';
			$ids = explode(',', $this->input->post($this->pk));
			if (count($ids) > 0) {
				if($this->model->delete($ids, $this->table)) {
					$this->vars = [
						'status' => 'success',
						'message' => 'deleted',
						'id' => $ids
					];
				} else {
					$this->vars = [
						'status' => 'error',
						'message' => 'not_deleted'
					];
				}
			}
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}

	/**
	 * Restored data | SET is_deleted to false
	 */
	public function restore() {
		if ($this->input->is_ajax_request()) {
			$this->vars['status'] = 'warning';
			$this->vars['message'] = 'not_selected';
			$ids = explode(',', $this->input->post($this->pk));
			if (count($ids) > 0) {
				if($this->model->restore($ids, $this->table)) {
					$this->vars = [
						'status' => 'success',
						'message' => 'restored',
						'id' => $ids
					];
				} else {
					$this->vars = [
						'status' => 'error',
						'message' => 'not_restored'
					];
				}
			}
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}

	/**
	 * Find by ID
	 * @return Object
	 */
	public function find_id() {
		if ($this->input->is_ajax_request()) {
			$id = _toInteger($this->input->post('id', true));
			$query = _isNaturalNumber( $id ) ? $this->model->RowObject($this->pk, $id, $this->table) : [];
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($query, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
	}

	/**
	 * Upload
	 * @return Object
	 */
	public function upload() {
		if ($this->input->is_ajax_request()) {
			$id = _toInteger($this->input->post('id', true));
			if (_isNaturalNumber( $id )) {
				$query = $this->model->RowObject($this->pk, $id, $this->table);
				$file_name = $query->photo;
				$config['upload_path'] = './media_library/users/photo/';
				$config['allowed_types'] = 'jpg|jpeg|png';
				$config['max_size'] = 512; // 512 KB
				$config['encrypt_name'] = TRUE;
				$this->load->library('upload');
				$this->upload->initialize($config);
				if (!$this->upload->do_upload('file')) {
					$this->vars['status'] = 'error';
					$this->vars['message'] = $this->upload->display_errors();
				} else {
					$upload = $this->upload->data();
					$query = $this->model->update($id, $this->table, ['photo' => $upload['file_name']]);
					if ($query) {
						@chmod(FCPATH.'media_library/users/photo/'.$upload['file_name'], 0777);
						@chmod(FCPATH.'media_library/users/photo/'.$file_name, 0777);
						@unlink(FCPATH.'media_library/users/photo/'.$file_name);
						$this->image_resize(FCPATH.'media_library/users/photo', $upload['file_name']);
					}
					$this->vars['status'] = 'success';
					$this->vars['message'] = 'uploaded';
				}
			}
			$this->output
				->set_content_type('application/json', 'utf-8')
				->set_output(json_encode($this->vars, self::REQUIRED_FLAGS))
				->_display();
			exit;
		}
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
		$config['maintain_ratio'] = true;
		$config['width'] = NULL !== __session('media')['user_photo_width'] && __session('media')['user_photo_width'] > 0 ? (int) __session('media')['user_photo_width'] : 250;
		$this->image_lib->initialize($config);
		$this->image_lib->resize();
	}	
}
