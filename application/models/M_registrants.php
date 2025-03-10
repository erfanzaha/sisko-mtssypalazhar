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

class M_registrants extends CI_Model {

	/**
	 * Primary key
	 * @var String
	 */
	public static $pk = 'id';

	/**
	 * Table
	 * @var String
	 */
	public static $table = 'users';

	/**
	 * Admission Year
	 * @var Integer
	 */
	public $admission_year;

	/**
	 * Class Constructor
	 *
	 * @return Void
	 */
	public function __construct() {
		parent::__construct();
		$year = __session('admission_year');
		$this->admission_year = (NULL !== $year && $year > 0) ? $year : date('Y');
	}

	/**
	 * Save Registration Form
	 * @param Array $dataset
	 * @param Array $subject_scores
	 * @return Boolean
	 */
	public function save_registration_form(array $dataset, array $subject_scores) {
		$this->db->trans_start();
		$this->db->insert(self::$table, $dataset);
		// Get last ID
		$student_id = $this->db->insert_id();
		// Update created_by
		$this->db->where(self::$pk, $student_id)->update(self::$table, ['created_by' => $student_id]);
		// Insert Student Subject Values
		if (count($subject_scores) > 0) {
			foreach($subject_scores as $subject_setting_detail_id => $score) {
				// convert to float number
				$score = str_replace(' ', '', trim($score));
				$score = str_replace(',', '.', $score);
				$score = floatval($score);
				$score = number_format($score, 2, '.', '');
				if ($score > 100) $score = 0.00;
				$this->db->set('subject_setting_detail_id', _toInteger($subject_setting_detail_id));
				$this->db->set('score', $score);
				$this->db->set('student_id', _toInteger($student_id));
				$this->db->set('created_by', _toInteger($student_id));
				$this->db->insert('admission_subject_scores');
			}
		}
		$this->db->trans_complete();
		return $this->db->trans_status();
	}

	/**
	 * Get Data
	 * @param String $keyword
	 * @param String $return_type
	 * @param Integer $limit
	 * @param Integer $offset
	 * @return Resource
	 */
	public function get_where($keyword = '', $return_type = 'count', $limit = 0, $offset = 0) {
		$fields = [
			'x1.id'
			, 'IF(x1.is_transfer = "true","Pindahan", "Baru") AS is_transfer'
			, 'x1.registration_number'
			, 'x1.re_registration'
			, 'LEFT(x1.created_at, 10) AS created_at'
			, 'x1.full_name'
			, 'x1.birth_date'
			, 'x1.gender'
			, 'x1.photo'
			, 'x4.option_name AS admission_type'
			, 'x5.phase_name'
			, 'x1.is_deleted'
		];
		if (__session('major_count') > 0) {
			array_push($fields, "COALESCE(x2.major_name, '-') AS first_choice");
			array_push($fields, "COALESCE(x3.major_name, '-') AS second_choice");
		}
		$this->db->select(implode(', ', $fields));
		if (__session('major_count') > 0) {
			$this->db->join('majors x2', 'x1.first_choice_id = x2.id', 'LEFT');
			$this->db->join('majors x3', 'x1.second_choice_id = x3.id', 'LEFT');
		}
		$this->db->join('options x4', 'x1.admission_type_id = x4.id', 'LEFT');
		$this->db->join('admission_phases x5', 'x1.admission_phase_id = x5.id', 'LEFT');
		$this->db->where('x1.is_prospective_student', 'true');
		$this->db->where('LEFT(x1.registration_number, 4) = ', $this->admission_year);
		if ( ! empty($keyword) ) {
			$this->db->group_start();
			$this->db->like('x1.full_name', $keyword);
			$this->db->or_like('x1.registration_number', $keyword);
			$this->db->or_like('x1.re_registration', $keyword);
			$this->db->or_like('x1.created_at', $keyword);
			if (__session('major_count') > 0) {
				$this->db->or_like('x2.major_name', $keyword);
				$this->db->or_like('x3.major_name', $keyword);
			}
			$this->db->or_like('x1.gender', $keyword);
			$this->db->or_like('x1.birth_place', $keyword);
			$this->db->or_like('x1.birth_date', $keyword);
			$this->db->or_like('x1.street_address', $keyword);
			$this->db->group_end();
		}
		if ( $return_type === 'count' ) return $this->db->count_all_results(self::$table . ' x1');
		if ( $limit > 0 ) $this->db->limit($limit, $offset);
		return $this->db->get(self::$table . ' x1');
	}

	/**
	 * Generate Registration Number
	 * @return Boolean
	 */
	public function registration_number() {
		$admission_year = $this->admission_year;
		$query = $this->db->query("
			SELECT MAX(RIGHT(registration_number, 6)) AS max_number
			FROM users
			WHERE is_prospective_student='true'
			AND LEFT(registration_number, 4) = ?
		", [$admission_year]);
		$registration_number = "000001";
		if ($query->num_rows() === 1) {
			$data = $query->row();
			$number = ((int) $data->max_number) + 1;
			$registration_number = sprintf("%06s", $number);
		}
		return $admission_year . $registration_number;
	}

	/**
	 * Selection Result
	 * @param String $registration_number
	 * @param String $birth_date
	 * @return Array
	 */
	public function selection_result($registration_number, $birth_date) {
		$query = $this->db
			->select('full_name, selection_result')
			->where('registration_number', $registration_number)
			->where('birth_date', $birth_date)
			->get(self::$table);
		if ($query->num_rows() === 1) {
			$result = $query->row();
			if (is_null($result->selection_result)) {
				return [
					'status' => 'info',
					'message' => 'Proses seleksi belum selesai.'
				];
			} else {
				if (__session('major_count') > 0) {
					if ($result->selection_result === 'unapproved') {
						return [
							'status' => 'info',
							'message' => 'Mohon Maaf '. $result->full_name . '<br>Anda Tidak Lolos Seleksi Penerimaan Peserta Didik Baru '.__session('school_profile')['school_name'].' Tahun '. $this->admission_year
						];
					} else {
						$majors = $this->model->RowObject('id', $result->selection_result, 'majors');
						return [
							'status' => 'success',
							'message' => 'Selamat '. $result->full_name.'!<br>Anda diterima di ' . $majors->major_name . ' ' . __session('school_profile')['school_name'].' Tahun '. $this->admission_year
						];
					}
				} else {
					if ($result->selection_result === 'unapproved') {
						return [
							'title' => 'info',
							'message' => 'Mohon Maaf '. $result->full_name . '<br>Anda Tidak Lolos Seleksi Penerimaan Peserta Didik Baru '.__session('school_profile')['school_name'].' Tahun '. $this->admission_year
						];
					} else {
						return [
							'status' => 'success',
							'message' => 'Selamat '. $result->full_name.'!<br>Anda Lolos Seleksi Penerimaan Peserta Didik Baru '.__session('school_profile')['school_name'].' Tahun '. $this->admission_year
						];
					}
				}
			}
		}

		return [
			'status' => 'warning',
			'message' => 'Data dengan tanggal lahir '.indo_date($birth_date).' dan nomor pendaftaran '.$registration_number.' tidak ditemukan.'
		];
	}

	/**
	 * Find Registrant
	 * @param String $registration_number
	 * @param String $birth_date
	 * @return Array
	 */
	public function find_registrant($registration_number, $birth_date) {
		$this->db->select("
			x1.*
		  , IF(x1.is_transfer='true', 'Pindahan', 'Baru') AS is_transfer
		  , IF(x1.gender = 'M', 'Laki-laki', 'Perempuan') AS gender
		  , x2.major_name AS first_choice
		  , x3.major_name AS second_choice
		  , x4.option_name AS religion
		  , x5.option_name AS special_needs
		  , x6.option_name AS admission_type
		  , x7.phase_name
		");
		$this->db->join('majors x2', 'x1.first_choice_id = x2.id', 'LEFT');
		$this->db->join('majors x3', 'x1.second_choice_id = x3.id', 'LEFT');
		$this->db->join('options x4', 'x1.religion_id = x4.id', 'LEFT');
		$this->db->join('options x5', 'x1.special_need_id = x5.id', 'LEFT');
		$this->db->join('options x6', 'x1.admission_type_id = x6.id', 'LEFT');
		$this->db->join('admission_phases x7', 'x1.admission_phase_id = x7.id', 'LEFT');
		$this->db->where('x1.registration_number', $registration_number);
		$this->db->where('x1.birth_date', $birth_date);
		return $this->db->get(self::$table.' x1')->row_array();
	}

	/**
	 * Admission Reports
	 * @return Resource
	 */
	public function admission_reports() {
		$this->load->model('m_students');
		$query = $this->m_students->student_query();
		$query .= "
		AND x1.is_prospective_student='true'
		ORDER BY x1.registration_number, x1.full_name ASC";
		return $this->db->query($query);
	}
}
