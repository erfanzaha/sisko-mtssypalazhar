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

class M_admission_subject_scores extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'admission_subject_scores';

	/**
	 * Get Subject Scores
	 * @param Integer $admission_year_id
	 * @param Integer $admission_type_id
	 * @param Integer $major_id
	 * @param String $subject_type
	 * @param String $return_type
	 * @param Integer $limit
	 * @param Integer $offset
	 * @return Resource
	 */
	public function get_subject_scores($admission_year_id = 0, $admission_type_id = 0, $major_id = 0, $subject_type = 'semester_report', $return_type = 'count', $limit = 0, $offset = 0) {
		$this->db->select('
			x1.id
			, x2.id AS student_id
			, x2.registration_number
			, x2.full_name
			, x4.id AS subject_id
			, x4.subject_name
			, x1.score
		');
		$this->db->join('users x2', 'x1.student_id = x2.id', 'LEFT');
		$this->db->join('admission_subject_setting_details x3', 'x1.subject_setting_detail_id = x3.id', 'LEFT');
		$this->db->join('subjects x4', 'x3.subject_id = x4.id', 'LEFT');
		$this->db->join('admission_subject_settings x5', 'x3.subject_setting_id = x5.id', 'LEFT');
		$this->db->where('x5.academic_year_id', $admission_year_id);
		$this->db->where('x5.admission_type_id', $admission_type_id);
		if (__session('major_count') > 0) {
			$this->db->where('x2.first_choice_id', $major_id);
		}
		$this->db->where('x5.subject_type', $subject_type);
		$this->db->where('x2.is_prospective_student', 'true');
		$this->db->where('x1.is_deleted', 'false');
		$this->db->where('x2.is_deleted', 'false');
		$this->db->where('x3.is_deleted', 'false');
		$this->db->where('x4.is_deleted', 'false');
		$this->db->where('x5.is_deleted', 'false');
		$this->db->order_by('x2.registration_number', 'ASC');
		$this->db->order_by('x4.subject_name', 'ASC');
		if ( $return_type === 'count' ) return $this->db->count_all_results(self::$table . ' x1');
		if ( $limit > 0 ) $this->db->limit($limit, $offset);
		return $this->db->get(self::$table . ' x1');
	}

	/**
	 * Save Admission Exam Scores
	 * @param Array
	 * @return Boolean
	 */
	public function save($params) {
		$counter = 0;
		foreach ($params as $row) {
			$score = str_replace(' ', '', trim($row['score']));
			$score = str_replace(',', '.', $score);
			$score = floatval($score);
			$score = number_format($score, 2, '.', '');
			if ($score > 100) {
				$score = 0.00;
			}
			$dataset = [
				'updated_by' => __session('user_id'),
				'score' => $score
			];
			$query = $this->db
				->where('id', $row['id'])
				->update(self::$table, $dataset);
			if ($query) {
				$counter++;
			}
		}

		return _isNaturalNumber( $counter );
	}

	/**
	 * Generate Subject Scores
	 * @param Integer $admission_year_id
	 * @param Integer $admission_type_id
	 * @param Integer $major_id
	 * @param String $subject_type
	 * @return 	Void
	 */
	public function generate_subject_scores($admission_year_id = 0, $admission_type_id = 0, $major_id = 0, $subject_type = 'semester_report') {
		// Define Admission Year
		$admission_year = $this->model->get_admission_year($admission_year_id);
		// Get Prospective Student ID
		$this->db->select('id');
		$this->db->where('is_prospective_student', 'true');
		$this->db->where('admission_type_id', $admission_type_id);
		$this->db->where('LEFT(registration_number, 4) =', $admission_year);
		if (__session('major_count') > 0) {
			$this->db->where('first_choice_id', $major_id);
		}
		if ($subject_type == 'exam_schedule') {
			$this->db->where('re_registration', 'true'); // Daftar Ulang
		}
		$this->db->where('is_deleted', 'false');
		$students = $this->db->get('users');
		if ($students->num_rows() > 0) {
			// Get ID From admission_subject_settings
			$this->db->select('id');
			$this->db->where('academic_year_id', $admission_year_id);
			$this->db->where('admission_type_id', $admission_type_id);
			$this->db->where('major_id', $major_id);
			$this->db->where('subject_type', $subject_type);
			$this->db->where('is_deleted', 'false');
			$admission_subject_settings = $this->db->get('admission_subject_settings');
			if ($admission_subject_settings->num_rows() === 1) {
				$admission_subject_setting = $admission_subject_settings->row();
				// Get ID From admission_subject_setting_details
				$admission_subject_setting_details = $this->db
					->select('id')
					->where('subject_setting_id', $admission_subject_setting->id)
					->where('is_deleted', 'false')
					->get('admission_subject_setting_details');
				if ($admission_subject_setting_details->num_rows() > 0) {
					foreach ($students->result() as $student) {
						foreach($admission_subject_setting_details->result() as $detail) {
							// Chek If Exist
							$count = $this->db
								->where('subject_setting_detail_id', $detail->id)
								->where('student_id', $student->id)
								->count_all_results(self::$table);
							if ($count === 0) {
								// Insert Subjects to admission_subject_scores
								$this->db->set('subject_setting_detail_id', $detail->id);
								$this->db->set('student_id', $student->id);
								$this->db->set('created_by', (int) __session('user_id'));
								$this->db->insert(self::$table);
							}
						}
					}
				}
			}
		}
	}
}
